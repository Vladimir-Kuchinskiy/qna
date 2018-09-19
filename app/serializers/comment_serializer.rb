# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :commentable_id, :commentable_type, :created_at, :updated_at

  belongs_to :question
end
