# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      before_action :set_question, only: :index

      def index
        respond_with(
          @answers = @question.answers,
          root: 'answers',
          adapter: :json
        )
      end

      def show
        respond_with(
          @answer = Answer.find(params[:id]),
          show_attachments: true,
          show_comments: true,
          root: 'answer',
          adapter: :json
        )
      end

      private

      def set_question
        @question = Question.find(params[:question_id])
      end
    end
  end
end