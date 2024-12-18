class MemberController < ApplicationController
  before_action :ensure_user_has_member_rights

  protected

  def ensure_user_has_member_rights
    not_found! unless Current.user.has_member_rights_at?(Current.platform)
  end
end
