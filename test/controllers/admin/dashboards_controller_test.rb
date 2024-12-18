require "test_helper"

module Admin
  class DashboardsControllerTest < ActionDispatch::IntegrationTest
    test "#index succeeds for super_admin" do
      login_as users(:super_admin)
      get admin_dashboard_path
      assert_response :success
    end

    test "#index succeeds for admin" do
      login_as users(:admin)
      get admin_dashboard_path
      assert_response :success
    end

    test "#index returns 404 for member" do
      login_as users(:member)
      get admin_dashboard_path
      assert_response :not_found
    end
  end
end
