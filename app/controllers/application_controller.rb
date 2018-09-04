require "application_responder"

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  rescue_from CanCan::AccessDenied do |e|
    flash.now[:error] = e.message
    render 'common/ajax_flash'
  end
end
