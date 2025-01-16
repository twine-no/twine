class ApplicationController < ActionController::Base
  include Authentication
  include ModalNavigation

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # Make an exception for the development environment to support the dev device console on Firefox
  allow_browser versions: :modern, if: -> { Rails.env.production? }

  def not_found!
    raise ActionController::RoutingError, "Not Found"
  end

  # Used to refresh the current page, useful for when successfully submitting a form through a modal
  # Seems to not work with Turbo morphing
  # Therefore, make sure pages that invoke this action
  # turbo_frame_tag :modal_content, refresh: :replace
  def turbo_page_refresh(notice: nil)
    flash[:notice] = notice if notice
    @turbo_refresh_method = :replace
    render turbo_stream: turbo_stream.refresh(request_id: nil)
  end
end
