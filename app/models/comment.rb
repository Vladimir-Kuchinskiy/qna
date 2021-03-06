# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :body, presence: true

  # If commentable is an Answer, then return question_id of it's answer,
  # else if commentable is a Question, then return it's id(commentable_id)
  def question_id
    commentable.attributes['question_id'] || commentable_id
  end

  class << self
    def search_for_question(query)
      ids = Comment.search(query).map do |comment|
        comment.commentable_type == 'Answer' ? comment.commentable.question.id : comment.commentable_id
      end
      Question.where(id: ids)
    end
  end
end
