# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :set_user, only: :verify_email
    before_action :check_user_verification!, only: :verify_email

    def verify_email
      if request.patch? && params[:user] && @user.update(user_params)
        redirect_to root_path, notice: 'Confirm your email please!'
      elsif request.patch?
        @user.email = ''
        render :verify_email
      end
      @user.email = ''
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def check_user_verification!
      if (current_user && (current_user.id != @user.id || current_user.email_verified?)) || @user.email_verified?
        redirect_to root_path
      end
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
