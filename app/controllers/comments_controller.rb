class CommentsController < ApplicationController
  before_action :authenticate_user!

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

end
