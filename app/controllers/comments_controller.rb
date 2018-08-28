class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action  :publish_comment, only: :create

  def create
    respond_to do |format|
      @comment = current_user.comments.new(comment_params)
      if @comment.save
        flash.now[:notice] = 'Your comment was successfully added'
        format.js
      else
        flash.now[:error] = 'Invalid comment'
        format.js { render 'common/ajax_flash' }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "comment_for_question_#{@comment.question_id}",
      comment: @comment.as_json.merge(email: @comment.user.email)
    )
  end

  def answer_to_publish
    answer = @answer.as_json(include: :attachments).merge(email: @answer.user.email)
    answer['attachments'].each { |a| a['name'] = a['file'].model['file'] }
    answer
  end

end
