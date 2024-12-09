class WelcomeController < ApplicationController
  allow_unauthenticated_access

  layout "logged_out"

  def index
    redirect_to after_authentication_url if authenticated?
  end
end
