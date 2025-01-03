class WelcomeController < ApplicationController
  allow_unauthenticated_access

  layout "logged_out"

  def index
    redirect_to after_authentication_url(Current.user) if authenticated?
  end
end
