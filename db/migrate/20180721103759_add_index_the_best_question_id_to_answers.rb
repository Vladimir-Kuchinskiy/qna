# frozen_string_literal: true

class AddIndexTheBestQuestionIdToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_index :answers, %i[the_best question_id], unique: true
  end
end
