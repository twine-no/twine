module Admin
  class SitesController < AdminController
    before_action :set_platform, only: [:show, :update]

    def show
    end

    def update
      if @platform.update(platform_params)
        redirect_to admin_site_path, notice: "Site updated."
      else
        render 'admin/sites/show', status: :unprocessable_content
      end
    end

    private

    def set_platform
      @platform = Current.platform
    end

    def platform_params
      params.require(:platform).permit(:logo, :name, :tagline, :shortname, :listed)
    end
  end
end
