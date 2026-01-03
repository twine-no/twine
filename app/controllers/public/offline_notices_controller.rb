module Public
  class OfflineNoticesController < PublicController
    def show
      render "public/platforms/offline"
    end
  end
end
