class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user, only: %i[facebook github]

  def facebook
    success_sign_in_and_redirect if @user.persisted?
    set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
  end

  def github
    if @user.email_verified?
      success_sign_in_and_redirect if @user.persisted?
      set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
    else
      redirect_to verify_email_path(@user)
    end
  end

  private

  def set_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end

  def success_sign_in_and_redirect
    sign_in_and_redirect @user, event: :authentication
  end
end