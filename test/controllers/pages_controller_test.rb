require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "#new succeeds" do
    login_as users(:new_recruit)
    get new_page_path
    assert_response :success
  end

  test "#new redirects to the editor when the user already has a page" do
    login_as users(:me)
    get new_page_path
    assert_redirected_to edit_page_path
  end

  test "#create succeeds" do
    login_as users(:new_recruit)
    assert_difference -> { Page.count } do
      post page_path, params: { page: { handle: "New Recruit" } }
    end
    assert_redirected_to edit_page_path

    assert_equal "new-recruit", users(:new_recruit).page.handle
    assert users(:new_recruit).page.published?
  end

  test "#create fails when the username is taken" do
    login_as users(:new_recruit)
    assert_no_difference -> { Page.count } do
      post page_path, params: { page: { handle: pages(:bakery).handle } }
    end
    assert_response :unprocessable_content
  end

  test "#edit succeeds" do
    login_as users(:me)
    pages(:bakery).avatar.attach(io: file_fixture("avatar.png").open, filename: "avatar.png")

    get edit_page_path
    assert_response :success
    assert_select "input[name='link[name]'][value=?]", links(:bakery_order_for_pickup).name
    assert_select ".phone a.linktree-link", count: pages(:bakery).links.count
  end

  test "#edit asks a user without a page to pick a username" do
    login_as users(:new_recruit)
    get edit_page_path
    assert_redirected_to new_page_path
  end

  test "#edit is only accessible when logged in" do
    get edit_page_path
    assert_redirected_to new_session_path
  end

  test "#update succeeds" do
    login_as users(:me)
    patch page_path, params: {
      page: { name: "Spring Bakery & Café", bio: "Now with seating.", avatar: file_fixture_upload("avatar.png", "image/png") }
    }
    assert_redirected_to edit_page_path

    assert_equal "Spring Bakery & Café", pages(:bakery).reload.name
    assert_equal "Now with seating.", pages(:bakery).bio
    assert pages(:bakery).avatar.attached?
  end

  test "#update unpublishes the page" do
    login_as users(:me)
    patch page_path, params: { page: { published: false } }
    assert_redirected_to edit_page_path

    assert_not pages(:bakery).reload.published?
  end

  test "#update refuses a picture that is not an image" do
    login_as users(:me)
    patch page_path, params: { page: { avatar: file_fixture_upload("not_an_image.txt", "text/plain") } }
    assert_redirected_to edit_page_path

    assert_equal "Picture must be a PNG, JPEG, WebP or GIF image", flash[:alert]
    assert_not pages(:bakery).reload.avatar.attached?
  end
end
