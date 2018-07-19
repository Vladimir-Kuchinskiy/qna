# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create update]
  before_action :set_answer,   only: %i[destroy update]
  before_action :can_destroy?, only: :destroy

  def create
    @answer = @question.answers.build(answer_params)
    respond_to do |format|
      if @answer.save
        current_user.answers << @answer
        flash.now[:notice] = 'Your answer was successfully created'
      else
        flash.now[:error] = 'Invalid answer'
      end
      format.js
    end
  end

  def update
    @answer.update(answer_params)
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
    params.require(:answer).permit(:body)
  end

  def can_destroy?
    if current_user != @answer.user
      redirect_to question_path(@answer.question), notice: 'Sorry! You can delete only your own answers'
    end
  end
end
