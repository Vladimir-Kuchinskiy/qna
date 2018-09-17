class Comment < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  Comment.import

  mapping do
    indexes :id, index: :not_analyzed
    indexes :title
    indexes :body
  end

  validates :body, presence: true

  # If commentable is an Answer, then return question_id of it's answer,
  # else if commentable is a Question, then return it's id(commentable_id)
  def question_id
    commentable.attributes['question_id'] || commentable_id
  end

  class << self
    def search_for_question(query)
      ids = Comment.search(query).records.records.map do |comment|
        comment.commentable_type == 'Answer' ? comment.commentable.question.id : comment.commentable_id
      end
      Question.where(id: ids)
    end
  end
end
