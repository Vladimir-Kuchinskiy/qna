# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def index
        respond_with(@profiles = User.where.not(id: current_resource_owner.id))
      end

      def me
        respond_with current_resource_owner
      end
    end
  end
end
