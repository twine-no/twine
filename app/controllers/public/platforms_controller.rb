module Public
  class PlatformsController < PublicController
    layout "site"

    before_action :set_platform, only: :show

    def show
    end

    private

    def set_platform
      @platform = Platform.listed.find_by!(shortname: params[:shortname])
    end

    def set_expiry
      expires_in ActiveStorage.service_urls_expire_in
    end
  end
end
