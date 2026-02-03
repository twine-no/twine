require "test_helper"

module Public
  module Platforms
    class AboutControllerTest < ActionDispatch::IntegrationTest
      test "#show succeeds" do
        platform = platforms(:political_chapter)
        platform.update!(about: "About text test")

        get public_site_about_path(platform.shortname)
        assert_response :success
        assert_includes @response.body, "About text test"
      end

      test "#show succeeds when about is empty" do
        platform = platforms(:political_chapter)
        platform.about = nil

        get public_site_about_path(platform.shortname)
        assert_response :success
      end
    end
  end
end
