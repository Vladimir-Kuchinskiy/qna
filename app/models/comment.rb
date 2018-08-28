class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  def question_id
    commentable.attributes['question_id'] || commentable_id
  end
end
