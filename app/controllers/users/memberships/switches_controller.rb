module Users
  module Memberships
    class SwitchesController < ApplicationController
      def create
        membership = Current.user.memberships.find(params[:membership_id])

        if Current.session.update(platform: membership.platform)
          redirect_to admin_dashboard_path
        else
          redirect_to me_path, alert: "Couldn't switch platform"
        end
      end
    end
  end
end
