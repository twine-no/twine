require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "#new succeeds" do
    get new_registration_path
    assert_response :success
  end

  test "#create succeeds with valid parameters, creates a new user, and redirects to admin onboarding" do
    assert_difference -> { User.count }, 1 do
      post registration_url, params: { user: { email: "new_user@example.com", password: "securepassword" } }
      assert_redirected_to admin_onboarding_path
      assert_equal "Welcome!", flash[:notice]
    end
  end

  test "#create fails with invalid parameters and re-renders the form" do
    assert_no_difference -> { User.count } do
      post registration_url, params: { user: { email: "", password: "short" } }
      assert_response :unprocessable_content
    end
  end
end
