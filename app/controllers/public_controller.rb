class PublicController < ApplicationController
  allow_unauthenticated_access

  layout "logged_out"

  protected

  def set_platform
    @platform =
      if on_custom_domain?
        Platform.listed.find_by(domain: request.host)
      else
        Platform.listed.find_by!(shortname: params[:shortname])
      end
  end
end
