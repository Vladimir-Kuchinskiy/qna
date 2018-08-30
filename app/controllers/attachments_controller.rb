# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :set_attachment

  respond_to :js

  def destroy
    respond_with(@attachment.destroy_if_owner(current_user)) do
      flash[:error] = 'Sorry! You can not delete this attachment' if @attachment.errors.any?
    end
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  def interpolation_options
    { resource_name: 'Your file' }
  end

end
