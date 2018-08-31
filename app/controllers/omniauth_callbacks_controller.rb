class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user, only: %i[facebook github]

  def facebook
    success_sign_in_and_redirect if @user.persisted?
  end

  def github
    success_sign_in_and_redirect if @user.persisted?
  end

  private

  def set_user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end

  def success_sign_in_and_redirect
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(
      :notice,
      :success, kind: request.env['omniauth.auth'].provider.titleize
    ) if is_navigational_format?
  end
end