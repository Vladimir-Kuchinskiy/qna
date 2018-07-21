# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question, optional: true
  belongs_to :user, optional: true

  validates :body, presence: true
  validates :the_best, uniqueness: { scope: :question_id }, if: ->(answer) { answer.the_best.present? }

  scope :from_the_best, -> { where(the_best: true) + where(the_best: nil).order('created_at') }

  def update_the_best
    question.answers.map { |a| a.update(the_best: nil) }
    update(the_best: true)
  end

  def can_operate?(current_user)
    current_user == user
  end
end
