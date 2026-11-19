class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_registration_url, alert: "Try again later." }

  def new
    if authenticated?
      redirect_to edit_page_path
    else
      @user = User.new(page: Page.new(handle: params[:handle]))
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for(@user)
      redirect_to edit_page_path, notice: "Welcome! Your linktree is live."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, page_attributes: [ :handle ])
  end
end
