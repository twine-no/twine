require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "#new succeeds" do
    get new_registration_path(handle: "astrid")
    assert_response :success
    assert_select "input[name='user[page_attributes][handle]'][value=astrid]"
  end

  test "#create succeeds" do
    assert_difference -> { User.count } => 1, -> { Page.count } => 1, -> { Session.count } => 1 do
      post registration_path, params: {
        user: { email: "astrid@example.com", password: "securepassword", page_attributes: { handle: "Astrid" } }
      }
    end
    assert_redirected_to edit_page_path

    assert_equal "astrid", User.find_by!(email: "astrid@example.com").page.handle
    assert Page.find_by!(handle: "astrid").published?
  end

  test "#create fails when the username is taken" do
    assert_no_difference -> { User.count } do
      post registration_path, params: {
        user: { email: "astrid@example.com", password: "securepassword", page_attributes: { handle: pages(:bakery).handle } }
      }
    end
    assert_response :unprocessable_content
    assert_select ".form-errors li", text: "Username has already been taken"
  end
end
