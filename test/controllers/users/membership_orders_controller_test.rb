require "test_helper"

module Users
  class MembershipOrdersControllerTest < ActionDispatch::IntegrationTest
    test "#update succeeds" do
      login_as users(:me), on: platforms(:coffee_shop)
      new_order = [
        memberships(:you_organise_the_football_meetup).id,
        memberships(:you_manage_the_coffee_shop).id,
        memberships(:you_sit_on_the_political_chapter_board).id
      ]
      patch users_membership_order_path, params: { order: new_order }, as: :json
      assert_response :ok
      assert_equal 0, memberships(:you_organise_the_football_meetup).reload.position
      assert_equal 1, memberships(:you_manage_the_coffee_shop).reload.position
      assert_equal 2, memberships(:you_sit_on_the_political_chapter_board).reload.position
    end

    test "#update redirects to login if not authenticated" do
      patch users_membership_order_path, params: { order: [] }, as: :json
      assert_redirected_to new_session_path
    end
  end
end
