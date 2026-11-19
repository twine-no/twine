class WelcomeController < ApplicationController
  allow_unauthenticated_access

  def index
    redirect_to edit_page_path if authenticated?
  end
end
