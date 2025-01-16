class PublicController < ApplicationController
  allow_unauthenticated_access

  layout "logged_out"
end
