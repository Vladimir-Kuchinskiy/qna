# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer,   only: %i[update vote dismiss_vote pick_up_the_best destroy]

  after_action :publish_answer, only: :create

  authorize_resource

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id))) do
      flash[:error] = 'Invalid answer' if @answer.errors.any?
    end
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer) { flash[:error] = 'Invalid answer' if @answer.errors.any? }
  end

  def vote
    respond_with(@answer.give_vote(current_user, params[:vote].to_i)) do
      flash[:error] = 'You can not vote for this answer' if @answer.errors.any?
    end
  end

  def dismiss_vote
    respond_with(@answer.remove_vote(current_user)) do |format|
      flash[:error] = 'You can not dismiss vote for this answer' if @answer.errors.any?
      format.js { render 'answers/vote' }
    end
  end

  def pick_up_the_best
    @question = @answer.question
    respond_with(@answer.update_the_best)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  private

  def flash_interpolation_options
    { resource_name: 'Your answer' }
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: %i[id file _destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "answer_for_question_#{params[:question_id]}",
      answer: answer_to_publish
    )
  end

  def answer_to_publish
    answer = @answer.as_json(include: :attachments).merge(email: @question.user.email)
    answer['attachments'].each { |a| a['name'] = a['file'].model['file'] }
    answer
  end
end
