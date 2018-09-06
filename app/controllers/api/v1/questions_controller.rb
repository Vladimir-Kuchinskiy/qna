# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      def index
        @questions = Question.all
        respond_with @questions.to_json(include: :answers)
      end
    end
  end
end