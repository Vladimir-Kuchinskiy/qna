# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      def index
        respond_with(
          @questions = Question.all,
          show_answers: true,
          show_attachments: false,
          show_comments: false
        )
      end

      def show
        respond_with(
          @question = Question.find(params[:id]),
          show_answers: false,
          show_attachments: true,
          show_comments: true
        )
      end
    end
  end
end