# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!,  except: %i[index show]
  before_action :set_question,        only: %i[show edit update vote dismiss_vote subscribe unsubscribe destroy]
  before_action :build_attachments,   only: :show
  before_action :beautify_search_url, only: :index

  after_action :publish_question, only: :create

  respond_to :js
  authorize_resource

  def index
    gon.push(current_user_id: current_user.id) if current_user.present?
    respond_with(@questions = Question.searching(params[:query], params[:type].try(:to_sym)).
        paginate(page: params[:page], per_page: 5))
  end

  def show
    gon.push(current_user_id: current_user.id) if current_user.present?
    gon.push(question_id: @question.id, question_user_id: @question.user_id)
    respond_with(@question)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params)) do
      flash[:error] = 'Invalid question' if @question.errors.any?
    end
  end

  def update
    @question.update(question_params)
    respond_with(@question) { flash[:error] = 'Invalid question' if @question.errors.any? }
  end

  def vote
    respond_with(@question.give_vote(current_user, params[:vote].to_i)) do |format|
      flash[:error] = 'You can not vote for this question' if @question.errors.any?
      format.js { render 'questions/vote', locals: { flag: params[:show] } }
    end
  end

  def dismiss_vote
    respond_with(@question.remove_vote(current_user)) do |format|
      flash[:error] = 'You can not dismiss vote for this question' if @question.errors.any?
      format.js { render 'questions/vote', locals: { flag: params[:show] } }
    end
  end

  def subscribe
    respond_with(@question.subscribe(current_user)) do
      flash[:error] = 'You can not subscribe for this question' if @question.errors.any?
    end
  end

  def unsubscribe
    respond_with(@question.unsubscribe(current_user)) do
      flash[:error] = 'You can not unsubscribe from this question' if @question.errors.any?
    end
  end

  def destroy
    respond_with(@question.destroy) { flash[:notice] = 'Your question was successfully deleted' }
  end

  private

  def beautify_search_url
    redirect_to search_questions_path(query: params[:q], type: params[:type]) if params[:q].present?
  end

  def flash_interpolation_options
    { resource_name: 'Your question' }
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions', @question.attributes.merge(email: @question.user.email))
  end

  def build_attachments
    @question.attachments.build unless @question.attachments.any?
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: %i[id file _destroy])
  end

  def set_question
    @question = Question.includes(:user).find(params[:id])
  end
end
