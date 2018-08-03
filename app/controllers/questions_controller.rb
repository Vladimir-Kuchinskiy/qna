# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question,       only: %i[show edit update vote dismiss_vote destroy]
  before_action :can_operate?,       only: %i[destroy update]
  before_action :build_attachments,  only: :show

  after_action :publish_question, only: :create

  def index
    @questions = Question.all
    gon.push(current_user_id: current_user.id) if current_user.present?
  end

  def show
    @answer = @question.answers.new
    @answer.attachments.build
  end

  def create
    @question = current_user.questions.build(question_params)
    respond_to do |format|
      if @question.save
        flash.now[:notice] = 'Your question was successfully created'
        format.js
      else
        flash.now[:error] = 'Invalid question'
        format.js { render 'common/ajax_flash' }
      end
    end
  end

  def update
    if @question.update(question_params)
      flash.now[:notice] = 'Your question was successfully updated'
    else
      flash.now[:error] = 'Invalid question'
    end
  end

  def vote
    respond_to do |format|
      if @question.give_vote(current_user, params[:vote].to_i)
        flash.now[:notice] = 'Your vote was successfully added'
        params[:show] ? format.js { render 'questions/update' } : format.js
      else
        flash.now[:error] = 'You can not vote for this question'
        format.js { render 'common/ajax_flash' }
      end
    end
  end

  def dismiss_vote
    respond_to do |format|
      if @question.remove_vote(current_user)
        flash.now[:notice] = 'Your vote was successfully dismissed'
        params[:show] ? format.js { render 'questions/update' } : format.js { render 'questions/vote' }
      else
        flash.now[:error] = 'You can not dismiss your vote for this question'
        format.js { render 'common/ajax_flash' }
      end
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question was successfully deleted'
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
