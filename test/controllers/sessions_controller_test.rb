require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "#new succeeds" do
    get new_session_path
    assert_response :success
  end

  test "#new redirects to the editor when already logged in" do
    login_as users(:me)
    get new_session_path
    assert_redirected_to edit_page_url
  end

  test "#create succeeds" do
    assert_difference -> { users(:dave).sessions.count } do
      post session_path, params: { email: users(:dave).email, password: "password" }
    end
    assert_redirected_to edit_page_url
  end

  test "#create fails when the password is wrong" do
    assert_no_difference -> { users(:dave).sessions.count } do
      post session_path, params: { email: users(:dave).email, password: "wrong password" }
    end
    assert_redirected_to new_session_path
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "#destroy succeeds" do
    login_as users(:dave)
    assert_difference -> { users(:dave).sessions.count }, -1 do
      delete session_path
    end
    assert_redirected_to new_session_path
  end
end
