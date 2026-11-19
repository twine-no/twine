require "test_helper"

module Public
  class PagesControllerTest < ActionDispatch::IntegrationTest
    test "#show succeeds" do
      pages(:bakery).avatar.attach(io: file_fixture("avatar.png").open, filename: "avatar.png")

      get public_page_path(pages(:bakery).handle)
      assert_response :success
      assert_select "h1", text: pages(:bakery).name
      assert_select "a.linktree-link[href=?]", links(:bakery_order_for_pickup).url, text: links(:bakery_order_for_pickup).name
      assert_select "a.linktree-link", count: pages(:bakery).links.count
    end

    test "#show returns 404 for an unpublished page" do
      get public_page_path(pages(:daves_draft).handle)
      assert_response :not_found
    end

    test "#show is served from the root of the page's own domain" do
      host! pages(:political_chapter).domain
      get "/"
      assert_response :success
      assert_select "h1", text: pages(:political_chapter).name
    end
  end
end
