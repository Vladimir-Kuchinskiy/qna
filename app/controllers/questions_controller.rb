# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question,       only: %i[show edit update vote dismiss_vote destroy]
  before_action :can_operate?,       only: %i[destroy update]
  before_action :build_attachments,  only: :show

  after_action :publish_question, only: :create

  respond_to :html, :js

  def index
    gon.push(current_user_id: current_user.id) if current_user.present?
    respond_with(@questions = Question.all)
  end

  def show
    gon.push(current_user_id: current_user.id) if current_user.present?
    gon.push(question_id: @question.id, question_user_id: @question.user_id)
    respond_with(@question)
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash.now[:notice] = 'Your question was successfully created'
    else
      flash.now[:error] = 'Invalid question'
    end
    respond_with @question
  end

  def update
    if @question.update(question_params)
      flash.now[:notice] = 'Your question was successfully updated'
    else
      flash.now[:error] = 'Invalid question'
    end
    respond_with @question
  end

  def vote
    if @question.give_vote(current_user, params[:vote].to_i)
      flash.now[:notice] = 'Your vote was successfully added'
    else
      flash.now[:error] = 'You can not vote for this question'
    end
    respond_with(@question) { |format| format.js { render 'questions/vote', locals: { flag: params[:show] } } }
  end

  def dismiss_vote
    if @question.remove_vote(current_user)
      flash.now[:notice] = 'Your vote was successfully dismissed'
    else
      flash.now[:error] = 'You can not dismiss your vote for this question'
    end
    respond_with(@question) { |format| format.js { render 'questions/vote', locals: { flag: params[:show] } } }
  end

  def destroy
    flash[:success] = 'Your question was successfully deleted'
    respond_with @question.destroy
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions', @question.attributes.merge(email: @question.user.email))
  end

  def build_attachments
    @question.attachments.build unless @question.attachments.any?
  end

  def can_operate?
    if current_user != @question.user
      flash.now[:error] = 'Sorry! You can operate only with your own questions'
      render 'common/ajax_flash'
    end
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: %i[id file _destroy])
  end

  def set_question
    @question = Question.includes(:user).find(params[:id])
  end
end
