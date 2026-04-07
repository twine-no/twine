require "test_helper"

class CustomDomainRootRoutingTest < ActionDispatch::IntegrationTest
  test "custom domain constrained root route helper exists and maps to root path" do
    assert_equal "/", Rails.application.routes.url_helpers.custom_domain_root_path
  end

  test "primary domain routes root to welcome#index" do
    get "/"
    assert_equal "welcome", @controller.controller_name
    assert_equal "index", @controller.action_name
  end

  test "root on political_chapter's custom domain routes to public/platforms#show" do
    params = Rails.application.routes.recognize_path("/", host: "kjelsasap.no")

    assert_equal "public/platforms", params[:controller]
    assert_equal "show", params[:action]
  end
end
