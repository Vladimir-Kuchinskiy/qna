# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      def index
        respond_with(
          @questions = Question.all,
          show_answers: true,
          root: :questions,
          adapter: :json
        )
      end

      def show
        respond_with(
          @question = Question.find(params[:id]),
          show_attachments: true,
          show_comments: true,
          root: :question,
          adapter: :json
        )
      end

      def create
        respond_with(
          @question = current_resource_owner.questions.create(question_params),
          root: :question,
          adapter: :json
        )
      end

      private

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end