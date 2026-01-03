module Public
  class PlatformsController < PublicController
    layout "site"

    before_action :set_platform, only: :show

    def show
    end
  end
end
