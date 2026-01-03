require "test_helper"

module Public
  class OfflineNoticesControllerTest < ActionDispatch::IntegrationTest
    test "#show succeeds" do
      get offline_notice_path
      assert_response :success
    end
  end
end
