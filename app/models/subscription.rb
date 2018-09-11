# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question, optional: true

  validates :question_id, uniqueness: { scope: :user_id }
end
