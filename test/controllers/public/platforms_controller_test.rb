require "test_helper"

module Public
  class PlatformsControllerTest < ActionDispatch::IntegrationTest
    test "#show succeeds for logged-out user" do
      get public_site_path(platforms(:political_chapter).shortname)
      assert_response :success
    end

    test "#show returns 404 for unlisted platform" do
      platforms(:coffee_shop).update!(listed: false)
      get public_site_path(platforms(:coffee_shop).shortname)
      assert_response :not_found
    end

    test "#show is accessible by custom domain" do
      host! platforms(:political_chapter).domain
      get "/"
      assert_response :success
    end

    test "redirects to offline notice for unlisted platform on its custom domain" do
      host! platforms(:coffee_shop).domain
      get "/"
      assert_redirected_to offline_notice_path
    end

    test "redirects to offline page for unknown custom domain with no platform" do
      host! "ghost.lvh.me"
      get "/"
      assert_redirected_to offline_notice_path
    end
  end
end
