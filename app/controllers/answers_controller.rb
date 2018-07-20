# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create update]
  before_action :set_answer,   only: %i[destroy update]
  before_action :can_operate?, only: %i[destroy update]

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
    if @answer.update(answer_params)
      flash.now[:notice] = 'Your answer was successfully updated'
    else
      flash.now[:error] = 'Invalid answer'
    end
  end

  def destroy
    @answer.destroy
    flash.now[:notice] = 'Your answer was successfully deleted'
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

  def can_operate?
    if current_user != @answer.user
      redirect_to question_path(@answer.question), notice: 'Sorry! You can operate only with your own answers'
    end
  end
end
