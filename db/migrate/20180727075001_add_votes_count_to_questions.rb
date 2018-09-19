# frozen_string_literal: true

class AddVotesCountToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :votes_count, :integer, default: 0
  end
end
