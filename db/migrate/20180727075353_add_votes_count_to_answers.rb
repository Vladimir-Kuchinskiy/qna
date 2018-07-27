class AddVotesCountToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :votes_count, :integer, default: 0
  end
end
