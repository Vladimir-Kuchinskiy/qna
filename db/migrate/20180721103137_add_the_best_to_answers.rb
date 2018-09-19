# frozen_string_literal: true

class AddTheBestToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :the_best, :boolean
  end
end
