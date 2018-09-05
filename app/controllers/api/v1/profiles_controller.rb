# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :doorkeeper_authorize!

      def me
        render body: nil
      end
    end
  end
end
