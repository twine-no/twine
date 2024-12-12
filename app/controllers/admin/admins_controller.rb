module Admin
  class AdminsController < ApplicationController
    def index
      redirect_to admin_dashboard_path, notice: 'not ready yet'
      @admins = Current.platform.memberships.admin
    end
  end
end
