# frozen_string_literal: true

class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :question
  belongs_to :user, optional: true
end
