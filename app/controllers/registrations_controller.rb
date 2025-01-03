class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  layout "logged_out"

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for(@user)
      redirect_to admin_onboarding_path, notice: "Welcome!"
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
