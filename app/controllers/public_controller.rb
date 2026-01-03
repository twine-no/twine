class PublicController < ApplicationController
  allow_unauthenticated_access

  layout "logged_out"

  protected

  def set_platform
      if on_custom_domain?
        # On custom domains, try to find the platform by domain regardless of listing.
        # If none exists yet, create a placeholder so we can render the offline page.
        @platform = Platform.listed.find_by(domain: request.host)
        redirect_to offline_notice_path unless @platform
      else
        @platform = Platform.listed.find_by!(shortname: params[:shortname])
      end
  end
end
