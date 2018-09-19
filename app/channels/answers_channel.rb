# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "answer_for_question_#{params[:question_id]}"
  end
end
