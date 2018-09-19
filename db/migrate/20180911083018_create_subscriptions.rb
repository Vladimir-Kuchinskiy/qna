# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :question, foreign_key: true

      t.timestamps
    end

    add_index :subscriptions, %i[question_id user_id], unique: true
  end
end
