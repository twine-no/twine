class AdminController < ApplicationController
  before_action :ensure_user_is_onboarded

  protected

  def ensure_user_is_onboarded
    redirect_to admin_onboarding_path unless Current.session.onboarded?
  end
end
