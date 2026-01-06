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

    test "#show displays upcoming event box when calendar has upcoming event" do
      get public_site_path(platforms(:political_chapter).shortname)
      assert_response :success
      assert_select "a[href=?]", public_events_path(shortname: platforms(:political_chapter).shortname)
      assert_select "span.font-medium", text: "Neste:"
      assert_select "a", text: /Årsmøte/
    end

    test "#show does not display upcoming event box when calendar does not have upcoming event" do
      get public_site_path(platforms(:football_meetup).shortname)
      assert_response :success
      assert_select "a[href=?]", public_events_path(shortname: platforms(:football_meetup).shortname), count: 0
    end
  end
end
