module Public
  class PlatformsController < PublicController
    layout "site"

    before_action :set_platform, only: :show

    def show
      expires_in ActiveStorage.service_urls_expire_in
    end

    private

    def set_platform
      @platform = Platform.listed.find_by!(shortname: params[:shortname])
    end
  end
end
