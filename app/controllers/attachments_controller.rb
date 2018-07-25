# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :set_attachment
  before_action :can_operate?

  def destroy
    @attachment.destroy
    flash.now[:notice] = 'Your file was successfully deleted'
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  def can_operate?
    if current_user != @attachment.attachable.user
      if @attachment.attachable_type == 'Question'
        redirect_to question_path(@attachment.attachable.id), notice: 'Sorry! You can operate only with your own questions'
      else
        redirect_to question_path(@attachment.attachable.question.id), notice: 'Sorry! You can operate only with your '\
                                                                            'own answers'
      end
    end
  end

end
