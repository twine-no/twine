require "test_helper"

module Admin
  class MembersControllerTest < ActionDispatch::IntegrationTest
    test "#index succeeds for admin" do
      login_as users(:admin)
      get admin_members_path
      assert_response :success
      log_out
    end

    test "#index returns 404 for member" do
      login_as users(:member)
      get admin_members_path
      assert_response :not_found
    end

    test "#index redirects to login page if you're not logged in" do
      get admin_members_path
      assert_redirected_to new_session_path
    end
  end
end
