class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :body
      t.integer :commentable_id
      t.string  :commentable_type
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
