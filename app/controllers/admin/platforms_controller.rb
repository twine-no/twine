module Admin
  class PlatformsController < ApplicationController
    def new
      @platform = Platform.new
    end

    def create
      @platform = Platform.new(platform_params)

      if @platform.save
        Current.user.memberships.create!(platform: @platform, role: :super_admin)
        Current.session.update!(platform: @platform)
        redirect_to admin_root_path, notice: "#{@platform.name} created!"
      else
        render :new, status: :unprocessable_content
      end
    end

    private

    def platform_params
      params.require(:platform).permit(:name)
    end
  end
end
