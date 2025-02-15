class AdminController < ApplicationController
  include Tableable

  before_action :ensure_user_is_onboarded
  before_action :ensure_user_has_admin_rights

  protected

  def ensure_user_is_onboarded
    redirect_to admin_onboarding_path unless Current.session.onboarded?
  end

  def ensure_user_has_admin_rights
    not_found! unless Current.user.has_admin_rights_at?(Current.platform)
  end
end
