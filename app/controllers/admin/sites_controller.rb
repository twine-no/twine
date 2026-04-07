module Admin
  class SitesController < AdminController
    include ImageUploadHandling

    before_action :set_platform, only: [ :show, :update ]
    before_action lambda {
      resize_image_file(platform_params[:logo], width: 300, height: 300)
    }, only: [ :update ]

    def show
    end

    def update
      if @platform.update(platform_params)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "site_content",
              partial: "public/platforms/site_content",
              locals: { platform: @platform }
            )
          end
          format.html { redirect_to admin_site_path, notice: "Site updated." }
        end
      else
        respond_to do |format|
          format.turbo_stream { render status: :unprocessable_content }
          format.html { render "admin/sites/show", status: :unprocessable_content }
        end
      end
    end

    private

    def set_platform
      @platform = Current.platform
    end

    def platform_params
      params.require(:platform).permit(
        :logo,
        :name,
        :tagline,
        :calendar_tagline,
        :about,
        :shortname,
        :listed,
        :life_area
      )
    end
  end
end
