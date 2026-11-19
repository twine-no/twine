require "test_helper"

class PublicPageRoutingTest < ActionDispatch::IntegrationTest
  test "the root of the primary domain shows the welcome page" do
    assert_recognizes({ controller: "welcome", action: "index" }, "http://example.com/")
  end

  test "the root of any other domain shows the page that owns that domain" do
    assert_recognizes({ controller: "public/pages", action: "show" }, "http://kjelsasap.no/")
  end

  test "addresses from when pages lived under /p/ redirect to the page" do
    get "/p/#{pages(:bakery).handle}"
    assert_redirected_to public_page_path(pages(:bakery).handle)
  end

  test "an unknown domain without a page returns 404" do
    host! "ghost.lvh.me"
    get "/"
    assert_response :not_found
  end
end
