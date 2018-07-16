class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer,   only: :destroy
  before_action :can_destroy?, only: :destroy

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question, notice: 'Answer was successfully created'
    else
      render 'questions/show'
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
