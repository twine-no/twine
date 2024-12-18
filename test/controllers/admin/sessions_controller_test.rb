require "test_helper"

module Admin
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test "#new succeeds" do
      get new_session_path
      assert_response :success
    end

    test "#new redirects to the member dashboard, if member is already signed in" do
      login_as users(:member)
      get new_session_path
      assert_redirected_to member_dashboard_path
    end

    test "#new redirects to the admin dashboard, if admin is already signed in" do
      login_as users(:admin)
      get new_session_path
      assert_redirected_to admin_dashboard_path
    end

    test "#create succeeds if email/password combination exists, logs in admin" do
      assert_difference -> { users(:admin).sessions.count } do
        post session_url, params: { email: users(:admin).email, password: "password" }
        assert_redirected_to admin_dashboard_path
      end
    end

    test "#create succeeds if email/password combination exists, logs in member" do
      assert_difference -> { users(:member).sessions.count } do
        post session_url, params: { email: users(:member).email, password: "password" }
        assert_redirected_to member_dashboard_path
      end
    end

    test "#create fails and redirects back to login page, if email/password combination does not exist" do
      assert_no_difference -> { users(:admin).sessions.count } do
        post session_url, params: { email: users(:admin).email, password: "wrong password" }
        assert_redirected_to new_session_path
        assert_equal "Try another email address or password.", flash[:alert]
      end
    end

    test "#destroy signs the user out" do
      login_as users(:member)
      assert_difference -> { users(:member).sessions.count }, -1 do
        delete session_url
        assert_redirected_to new_session_path
        assert_equal "You have signed out.", flash[:notice]
      end
    end
  end
end
