require "test_helper"

module Admin
  class PlatformsControllerTest < ActionDispatch::IntegrationTest
    test "#create succeeds" do
      login_as users(:me), on: platforms(:coffee_shop)
      assert_difference -> { Platform.count } do
        post admin_platform_path, params: { platform: { name: "New Platform" } }
      end
      assert_redirected_to admin_root_path
    end

    test "#create redirects to login if not authenticated" do
      post admin_platform_path, params: { platform: { name: "New Platform" } }
      assert_redirected_to new_session_path
    end
  end
end
