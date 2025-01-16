module Public
  class PlatformsController < PublicController
    def show
    end

    private

    def set_platform
      @platform = Platform.listed.find_by!(shortname: params[:shortname])
    end
  end
end
