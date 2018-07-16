class AddBelongsToQuestionsUser < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :questions, :user, index: true
  end
end
