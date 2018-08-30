class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  # If commentable is an Answer, then return question_id of it's answer,
  # else if commentable is a Question, then return it's id(commentable_id)
  def question_id
    commentable.attributes['question_id'] || commentable_id
  end
end
