module Admin
  class SitesController < AdminController
    before_action :set_platform, only: [:show, :update]
    before_action lambda {
      resize_logo_file(platform_params[:logo], width: 200, height: 200)
    }, only: [:update]

    def show
    end

    def update
      if @platform.update(platform_params)
        redirect_to admin_site_path, notice: "Site updated."
      else
        render "admin/sites/show", status: :unprocessable_content
      end
    end

    private

    def set_platform
      @platform = Current.platform
    end

    def platform_params
      params.require(:platform).permit(:logo, :name, :tagline, :shortname, :listed)
    end

    def resize_logo_file(image_param, width:, height:)
      return unless image_param

      ImageProcessing::MiniMagick
        .source(image_param)
        .resize_to_fit(width, height)
        .call(destination: image_param.tempfile.path)
    end
  end
end
