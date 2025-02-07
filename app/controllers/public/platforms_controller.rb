module Public
  class PlatformsController < PublicController
    layout "site"

    before_action :set_platform, only: :show

    def show
      no_store
    end

    private

    def set_platform
      @platform = Platform.listed.find_by!(shortname: params[:shortname])
    end
  end
end
