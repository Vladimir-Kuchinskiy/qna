class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question,       only: %i[show edit update destroy]
  before_action :can_destroy?,       only: :destroy

  def index
    @questions = Question.all
  end

  def show; end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question was successfully created'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Your question was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question was successfully deleted'
  end

  private

  def can_destroy?
    if current_user != @question.user
      redirect_to questions_path, notice: 'Sorry! You can delete only your own questions'
    end
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
