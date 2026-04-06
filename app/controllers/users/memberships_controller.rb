module Users
  class MembershipsController < ApplicationController
    layout "memberships"

    def show
      @memberships = Current.user.memberships.includes(:platform).where.not(role: :invited).order(:created_at)
    end
  end
end
