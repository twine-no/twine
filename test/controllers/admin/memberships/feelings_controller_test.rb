require "test_helper"

module Admin
  module Memberships
    class FeelingsControllerTest < ActionDispatch::IntegrationTest
      test "#update succeeds" do
        login_as users(:me), on: platforms(:coffee_shop)
        patch admin_membership_feeling_path(memberships(:you_manage_the_coffee_shop)), params: { feeling: 75 }
        assert_response :ok
        assert_equal 75, memberships(:you_manage_the_coffee_shop).reload.feeling
      end

      test "#update redirects to login if not authenticated" do
        patch admin_membership_feeling_path(memberships(:you_manage_the_coffee_shop)), params: { feeling: 75 }
        assert_redirected_to new_session_path
      end
    end
  end
end
