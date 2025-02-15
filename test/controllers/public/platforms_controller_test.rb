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
  end
end
