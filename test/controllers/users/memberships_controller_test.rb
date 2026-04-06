require "test_helper"

module Users
  class MembershipsControllerTest < ActionDispatch::IntegrationTest
    test "#show succeeds" do
      login_as users(:me), on: platforms(:coffee_shop)
      get me_path
      assert_response :success
    end

    test "#show redirects to login if not authenticated" do
      get me_path
      assert_redirected_to new_session_path
    end
  end
end
