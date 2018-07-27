class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.belongs_to :user,     foreign_key: true, index: true
      t.belongs_to :question, foreign_key: true, index: true
      t.belongs_to :answer,   foreign_key: true, index: true
      t.boolean :voted

      t.timestamps
    end
  end
end
