require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "#index succeeds" do
    get root_path
    assert_response :success
    assert_select "h1", text: "Get a free linktree"
    assert_select "p", text: "🇳🇴 Made in Norway"
  end

  test "#index redirects to the editor when logged in" do
    login_as users(:me)
    get root_path
    assert_redirected_to edit_page_path
  end
end
