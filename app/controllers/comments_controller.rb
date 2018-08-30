class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  after_action  :publish_comment, only: :create

  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id))) do
      flash[:error] = 'Invalid comment' if @comment.errors.any?
    end
  end

  private

  def set_commentable
    @commentable = Question.find(params[:question_id]) if params[:question_id]
    @commentable ||= Answer.find(params[:answer_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "comment_for_question_#{@comment.question_id}",
      comment: @comment.as_json.merge(email: @comment.user.email)
    )
  end
end
