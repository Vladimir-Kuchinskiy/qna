class AddVoteableIdVoteableTypeIndexToVotes < ActiveRecord::Migration[5.2]
  def change
    add_index :votes, %i[voteable_type voteable_id]
  end
end
