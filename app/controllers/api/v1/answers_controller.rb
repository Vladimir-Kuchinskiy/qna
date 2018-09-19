# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      before_action :set_question, only: %i[index create]

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

      def create
        respond_with(
          @answer = @question.answers.create(answer_params.merge(user_id: current_resource_owner.id)),
          root: :answer,
          adapter: :json
        )
      end

      private

      def set_question
        @question = Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
