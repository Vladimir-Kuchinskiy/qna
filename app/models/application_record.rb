# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  TYPES = {
    question: 'Questions',
    answer: 'Answers',
    comment: 'Comments'
  }

  self.abstract_class = true
end
