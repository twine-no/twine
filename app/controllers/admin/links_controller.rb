module Admin
  class LinksController < AdminController
    before_action :set_link, only: [:update, :destroy]

    def new
      @link = Current.platform.links.new
      redirect_to admin_site_path unless turbo_frame_request?
    end

    def create
      @link = Current.platform.links.new(link_params)
      if @link.save
        redirect_to admin_site_path
      else
        render "admin/links/new", status: :unprocessable_content
      end
    end

    def update
      if @link.update(link_params)
        redirect_to admin_site_path
      else
        redirect_to admin_site_path, notice: "Couldn't update link"
      end
    end

    def destroy
      @link.destroy!
      redirect_to admin_site_path
    end

    private

    def set_link
      @link = Current.platform.links.find(params[:id])
    end

    def link_params
      params.require(:link).permit(:name, :url)
    end
  end
end
