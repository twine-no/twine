require "test_helper"

module Links
  class OrdersControllerTest < ActionDispatch::IntegrationTest
    test "#update succeeds" do
      login_as users(:me)
      patch links_order_path, params: { link_ids: [ links(:bakery_menu).id, links(:bakery_order_for_pickup).id ] }
      assert_redirected_to edit_page_path

      assert_equal [ links(:bakery_menu), links(:bakery_order_for_pickup) ], pages(:bakery).links.to_a
    end

    test "#update changes nothing when given a link on somebody else's page" do
      login_as users(:me)
      assert_no_changes -> { Link.order(:id).pluck(:position) } do
        patch links_order_path, params: {
          link_ids: [ links(:bakery_menu).id, links(:political_chapter_become_a_member).id, links(:bakery_order_for_pickup).id ]
        }
      end
      assert_response :not_found
    end
  end
end
