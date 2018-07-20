# frozen_string_literal: true

class Question < ApplicationRecord
  has_many   :answers
  belongs_to :user, optional: true

  validates :title, :body, presence: true

  def can_operate?(current_user)
    current_user == user
  end
end
