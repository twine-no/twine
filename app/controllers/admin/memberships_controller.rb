module Admin
  class MembershipsController < ApplicationController
    layout "memberships"

    def show
      @memberships = Current.user.memberships.includes(:platform).where.not(role: :invited).order(:created_at)
    end

    def update_feeling
      membership = Current.user.memberships.find(params[:id])
      membership.update!(feeling: params[:feeling].to_i.clamp(0, 100))
      head :ok
    end

    def switch
      membership = Current.user.memberships.find(params[:id])
      if Current.session.update(platform: membership.platform)
        redirect_to admin_dashboard_path
      else
        redirect_to admin_root_path, alert: "Couldn't switch platform"
      end
    end
  end
end
