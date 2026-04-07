module Users
  class MembershipsController < ApplicationController
    layout "overview"

    def show
      @memberships = Current.user.memberships.includes(:platform).where.not(role: :invited).order(:position, :created_at)
    end
  end
end
