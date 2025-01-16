module Admin
  class SitesController < AdminController
    before_action :set_platform, only: :show

    def show

    end

    private

    def set_platform
      @platform = Current.platform
    end
  end
end
