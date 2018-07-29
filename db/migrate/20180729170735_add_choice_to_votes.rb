class AddChoiceToVotes < ActiveRecord::Migration[5.2]
  def change
    add_column :votes, :choice, :integer
  end
end
