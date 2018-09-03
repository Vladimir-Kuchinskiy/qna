class RegistrationsController < Devise::RegistrationsController

  def verify_email
    @user = User.find(params[:id])
    redirect_to root_path, notice: 'Your need confirm your email!' if request.patch? && params[:user] && @user.update(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end