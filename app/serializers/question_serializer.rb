# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_at, :updated_at, :short_title
  has_many :answers, if: -> { show_answers }
  has_many :attachments, if: -> { show_attachments }
  has_many :comments, if: -> { show_comments }

  def short_title
    object.title.truncate(10)
  end

  private

  def show_answers
    @instance_options[:show_answers]
  end

  def show_attachments
    @instance_options[:show_attachments]
  end

  def show_comments
    @instance_options[:show_comments]
  end
end
