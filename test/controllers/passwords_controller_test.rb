require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "#new succeeds" do
    get new_password_path
    assert_response :success
  end

  test "#create succeeds" do
    assert_emails 1 do
      post passwords_path, params: { email: users(:dave).email }
    end
    assert_redirected_to new_session_path
  end

  test "#edit succeeds" do
    get edit_password_path(users(:dave).password_reset_token)
    assert_response :success
  end

  test "#update succeeds" do
    assert_changes -> { users(:dave).reload.password_digest } do
      patch password_path(users(:dave).password_reset_token), params: {
        password: "newpassword",
        password_confirmation: "newpassword"
      }
    end
    assert_redirected_to new_session_path
  end
end
