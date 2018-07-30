class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.belongs_to :user, foreign_key: true, index: true
      t.integer :voteable_id
      t.string  :voteable_type
      t.integer :choice
      t.boolean :voted
      t.timestamps
    end
  end
end
