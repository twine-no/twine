require "test_helper"

module Users
  module Memberships
    class SwitchesControllerTest < ActionDispatch::IntegrationTest
      test "#create succeeds" do
        login_as users(:me), on: platforms(:coffee_shop)
        post users_membership_switch_path(memberships(:you_organise_the_football_meetup))
        assert_redirected_to admin_dashboard_path
      end

      test "#create redirects to login if not authenticated" do
        post users_membership_switch_path(memberships(:you_organise_the_football_meetup))
        assert_redirected_to new_session_path
      end
    end
  end
end
