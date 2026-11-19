class ApplicationController < ActionController::Base
  include Authentication
  include DomainsHelper

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # Make an exception for the development environment to support the dev device console on Firefox
  allow_browser versions: :modern, if: -> { Rails.env.production? }
end
