# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  TYPES = {
    question: 'Questions',
    answer: 'Answers',
    comment: 'Comments'
  }.freeze

  self.abstract_class = true
end
