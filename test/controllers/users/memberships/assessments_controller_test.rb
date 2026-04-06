require "test_helper"

module Users
  module Memberships
    class AssessmentsControllerTest < ActionDispatch::IntegrationTest
      test "#create succeeds" do
        login_as users(:me), on: platforms(:coffee_shop)
        assert_difference -> { Assessment.count } do
          post users_membership_assessments_path(memberships(:you_manage_the_coffee_shop)),
               params: { value: 75 }
        end
        assert_response :ok
        assert_equal 75, memberships(:you_manage_the_coffee_shop).reload.feeling
      end

      test "#create redirects to login if not authenticated" do
        post users_membership_assessments_path(memberships(:you_manage_the_coffee_shop)),
             params: { value: 75 }
        assert_redirected_to new_session_path
      end
    end
  end
end
