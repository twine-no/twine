module Admin
  class WellbeingController < ApplicationController
    layout "wellbeing"

    def show
      @memberships = Current.user.memberships.includes(:platform).where.not(role: :invited).order(:created_at)
    end

    def update_feeling
      membership = Current.user.memberships.find(params[:id])
      membership.update!(feeling: params[:feeling].to_i.clamp(0, 100))
      head :ok
    end
  end
end
