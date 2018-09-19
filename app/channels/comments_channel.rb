# frozen_string_literal: true

class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comment_for_question_#{params[:question_id]}"
  end
end
