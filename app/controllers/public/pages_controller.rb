module Public
  class PagesController < ApplicationController
    allow_unauthenticated_access

    layout "public_page"

    def show
      @page = if on_custom_domain?
        Page.find_by!(published: true, domain: request.host)
      else
        Page.find_by!(published: true, handle: params[:handle])
      end
    end
  end
end
