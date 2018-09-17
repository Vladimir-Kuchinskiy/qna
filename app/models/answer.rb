# frozen_string_literal: true

class Answer < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include Voteable
  include ReputationCalculatable

  has_many :attachments, as: :attachable,  dependent: :destroy
  has_many :comments,    as: :commentable, dependent: :destroy

  belongs_to :question, optional: true
  belongs_to :user, optional: true

  Answer.import

  mapping do
    indexes :id, index: :not_analyzed
    indexes :body
  end

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true
  validates :the_best, uniqueness: { scope: :question_id }, if: ->(answer) { answer.the_best.present? }

  after_create :notify_users

  scope :from_the_best, -> { where(the_best: true) + where(the_best: nil).order('created_at') }

  def update_the_best
    question.answers.where(the_best: true).first.update(the_best: nil) if question.answers.where(the_best: true).any?
    update(the_best: true)
    self
  end

  class << self
    def search_for_question(query)
      answers = Answer.search(query).records.records
      answers.any? ? Question.where(id: answers.map(&:question).map(&:id)) : Question.none
    end
  end

  def notify_users
    NotifyQuestionUsersJob.perform_later(self)
  end
end
