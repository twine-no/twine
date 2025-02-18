require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "#new succeeds" do
    get new_password_path
    assert_response :success
  end

  test "#create succeeds and sends the password reset instructions by email" do
    assert_emails 1 do
      post passwords_url, params: { email: users(:dave).email }
    end
    assert_redirected_to new_session_path
  end

  test "#edit succeeds" do
    get edit_password_path(users(:dave).password_reset_token)
    assert_response :success
  end

  test "#update succeeds, allows user to set a new password" do
    assert_changes -> { users(:dave).reload.password_digest } do
      patch password_url(users(:dave).password_reset_token), params: {
        password: "newpassword",
        password_confirmation: "newpassword"
      }
    end
    assert_redirected_to new_session_path
  end
end
