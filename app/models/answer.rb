# frozen_string_literal: true

class Answer < ApplicationRecord
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, dependent: :destroy

  belongs_to :question, optional: true
  belongs_to :user, optional: true

  accepts_nested_attributes_for :attachments

  validates :body, presence: true
  validates :the_best, uniqueness: { scope: :question_id }, if: ->(answer) { answer.the_best.present? }

  scope :from_the_best, -> { where(the_best: true) + where(the_best: nil).order('created_at') }

  def update_the_best
    question.answers.map { |a| a.update(the_best: nil) }
    update(the_best: true)
  end

  def give_vote(current_user, vote)
    if !can_vote?(current_user)
      false
    else
      ActiveModel::Type::Boolean.new.cast(vote) ? self.votes_count += 1 : self.votes_count -= 1
      current_user.vote(self)
      save
    end
  end

  private

  def can_vote?(current_user)
    current_user != user && !current_user.votes.find_by(answer_id: id).try(:voted)
  end
end
