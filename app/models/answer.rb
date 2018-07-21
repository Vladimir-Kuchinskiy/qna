# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question, optional: true
  belongs_to :user, optional: true

  validates :body, presence: true
  validates :the_best, uniqueness: { scope: :question_id }

  def can_operate?(current_user)
    current_user == user
  end
end
