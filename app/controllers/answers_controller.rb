# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create update vote dismiss_vote pick_up_the_best]
  before_action :set_answer,   only: %i[update vote dismiss_vote pick_up_the_best destroy]
  before_action :can_operate?, only: %i[destroy update]

  after_action :publish_answer, only: :create

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
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

  def vote
    respond_to do |format|
      if @answer.give_vote(current_user, params[:vote].to_i)
        flash.now[:notice] = 'Your vote was successfully added'
        format.js
      else
        flash.now[:error] = 'You can not vote for this answer'
        format.js { render 'common/ajax_flash' }
      end
    end
  end

  def dismiss_vote
    respond_to do |format|
      if @answer.remove_vote(current_user)
        flash.now[:notice] = 'Your vote was successfully dismissed'
        format.js { render 'answers/vote' }
      else
        flash.now[:error] = 'You can not dismiss your vote for this answer'
        format.js { render 'common/ajax_flash' }
      end
    end
  end

  def pick_up_the_best
    @answer.update_the_best
    flash.now[:notice] = 'The answer was successfully marked as the best'
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

  def can_operate?
    if current_user != @answer.user
      redirect_to question_path(@answer.question), notice: 'Sorry! You can operate only with your own answers'
    end
  end
end
