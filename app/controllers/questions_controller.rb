# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question,       only: %i[show edit update destroy]
  before_action :can_operate?,       only: %i[destroy update]

  def index
    @questions = Question.all
  end

  def show; end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question was successfully created'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      flash.now[:notice] = 'Your question was successfully updated'
    else
      flash.now[:error] = 'Invalid question'
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question was successfully deleted'
  end

  private

  def can_operate?
    if current_user != @question.user
      redirect_to questions_path, notice: 'Sorry! You can operate only with your own questions'
    end
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
