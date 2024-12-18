module Admin
  class MembersController < AdminController
    def index
      platform_memberships = Current.platform.memberships.joins(:user)
      set_data_table_page platform_memberships
    end
  end
end
