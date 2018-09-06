# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      def index
        respond_with(@questions = Question.all)
      end
    end
  end
end