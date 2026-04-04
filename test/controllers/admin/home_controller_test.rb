require "test_helper"

module Admin
  class HomeControllerTest < ActionDispatch::IntegrationTest
    test "#show succeeds" do
      login_as users(:me), on: platforms(:coffee_shop)
      get admin_root_path
      assert_response :success
    end

    test "#show redirects to login if not authenticated" do
      get admin_root_path
      assert_redirected_to new_session_path
    end
  end
end
