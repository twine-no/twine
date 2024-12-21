class ApplicationController < ActionController::Base
  include Authentication
  include ModalNavigation

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern, if: -> { Rails.env.production? }

  def not_found!
    raise ActionController::RoutingError, "Not Found"
  end
end
