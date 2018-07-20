# frozen_string_literal: true

class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :question, optional: true
  belongs_to :user, optional: true
end
