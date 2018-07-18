# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer,   only: :destroy
  before_action :can_destroy?, only: :destroy

  def create
    @answer = @question.answers.build(answer_params)
    respond_to do |format|
      if @answer.save
        flash.now[:notice] = 'Your answer was successfully created'
      else
        flash.now[:error] = 'Invalid answer'
      end

      format.js
    end
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question, notice: 'Your answer was successfully deleted'
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end

  def can_destroy?
    if current_user != @answer.user
      redirect_to question_path(@answer.question), notice: 'Sorry! You can delete only your own answers'
    end
  end
end
