# frozen_string_literal: true

class AddIndexesToComments < ActiveRecord::Migration[5.2]
  def change
    add_index :comments, %i[commentable_type commentable_id]
  end
end
