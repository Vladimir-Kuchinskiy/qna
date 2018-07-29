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
    question.answers.where(the_best: true).first.update(the_best: nil) if question.answers.where(the_best: true).any?
    update(the_best: true)
  end

  def give_vote(current_user, vote)
    if current_user.can_vote?(self)
      self.votes_count += vote if current_user.vote(self, vote)
      save
    else
      false
    end
  end

  def remove_vote(current_user)
    if current_user.can_dismiss?(self)
      self.votes_count -= current_user.votes.find_by(answer_id: id).choice
      current_user.dismiss_vote(self)
      save
    else
      false
    end
  end
end
