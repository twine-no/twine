class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  layout "logged_out"

  def new
    redirect_to after_authentication_url(Current.user) if authenticated?
  end

  def create
    if user = User.authenticate_by(params.permit(:email, :password))
      start_new_session_for user
      redirect_to after_authentication_url(user)
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def update
    membership = Current.user.memberships.with_admin_rights.find_by(platform_id: session_params[:platform_id])

    if membership&.platform && Current.session.update(platform: membership.platform)
      redirect_to root_path, notice: "Changed to #{membership.platform.name}"
    else
      redirect_to root_path, alert: "Couldn't change platform"
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: "You have signed out."
  end

  private

  def session_params
    params.require(:session).permit(:platform_id)
  end
end
