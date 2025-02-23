require "test_helper"

module Admin
  class LinksControllerTest < ActionDispatch::IntegrationTest
    test "#new succeeds for admin" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get new_admin_link_path
      assert_response :success
    end

    test "#new succeeds for admin even when Platform has no links" do
      login_as users(:admin), on: platforms(:coffee_shop)
      platforms(:coffee_shop).links.destroy_all
      get new_admin_link_path
      assert_response :success
    end

    test "#new redirects to login page unless logged in" do
      get new_admin_link_path
      assert_redirected_to new_session_path
    end

    test "#create adds a new Link to the Platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_difference -> { platforms(:coffee_shop).links.count }, 1 do
        post admin_links_path, params: { link: { name: "New Link", url: "example.com" } }
      end
      assert_redirected_to admin_site_path

      created_link = Link.last
      assert_equal "New Link", created_link.name
      assert_equal "https://example.com", created_link.url # adds https:// to the URL
      assert_not_nil created_link.position
    end

    test "#create can add a link even when one hasn't been previously added" do
      login_as users(:admin), on: platforms(:coffee_shop)
      platforms(:coffee_shop).links.destroy_all
      assert_difference -> { platforms(:coffee_shop).links.count }, 1 do
        post admin_links_path, params: { link: { name: "New Link", url: "example.com" } }
      end
      assert_redirected_to admin_site_path

      created_link = Link.last
      assert_equal "New Link", created_link.name
      assert_equal "https://example.com", created_link.url # adds https:// to the URL
      assert_not_nil created_link.position
    end

    test "#create sets and increments position on each Link" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_difference -> { platforms(:coffee_shop).links.count }, 2 do
        post admin_links_path, params: { link: { name: "Link 1", url: "example.com" } }
        created_link_1 = Link.last
        post admin_links_path, params: { link: { name: "Link 2", url: "example2.com" } }
        created_link_2 = Link.last

        assert_equal created_link_1.position + 1, created_link_2.position
      end
      assert_redirected_to admin_site_path
    end

    test "#update updates name and URL of link" do
      login_as users(:admin), on: platforms(:coffee_shop)
      link = platforms(:coffee_shop).links.create!(name: "Old Name", url: "old.com")
      patch admin_link_path(link), params: { link: { name: "New Name", url: "new.com" } }
      assert_redirected_to admin_site_path

      link.reload
      assert_equal "New Name", link.name
      assert_equal "https://new.com", link.url
    end

    test "#update prevents you from updating another platform's link" do
      login_as users(:admin), on: platforms(:coffee_shop)
      old_name = links(:political_chapter_our_platform).name
      old_url = links(:political_chapter_our_platform).url

      patch admin_link_path(links(:political_chapter_our_platform)), params: { link: { name: "New Name", url: "new.com" } }
      assert_response :not_found

      links(:political_chapter_our_platform).reload
      assert_equal old_name, links(:political_chapter_our_platform).name
      assert_equal old_url, links(:political_chapter_our_platform).url
    end

    test "#destroy removes a link from the Platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      link = platforms(:coffee_shop).links.create!(name: "Link", url: "example.com")
      assert_difference -> { platforms(:coffee_shop).links.count }, -1 do
        delete admin_link_path(link)
      end
      assert_redirected_to admin_site_path
    end

    test "#destroy prevents you from deleting another platform's link" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_no_difference -> { Link.count } do
        delete admin_link_path(links(:political_chapter_our_platform))
      end
      assert_response :not_found
    end

    test "#sort updates the position of each link" do
      login_as users(:dave), on: platforms(:political_chapter)
      links(:political_chapter_our_platform).update!(position: 0)
      links(:political_chapter_become_member).update!(position: 1)

      # The order of the links is reversed
      patch sort_admin_links_path, params: {
        order: [
          links(:political_chapter_become_member).id,
          links(:political_chapter_our_platform).id
        ]
      }
      assert_response :success

      assert_equal 0, links(:political_chapter_become_member).reload.position
      assert_equal 1, links(:political_chapter_our_platform).reload.position
    end

    test "#sort won't affect links from other platforms" do
      login_as users(:dave), on: platforms(:political_chapter)
      links(:political_chapter_our_platform).update!(position: 0)
      coffee_shop_link = platforms(:coffee_shop).links.create!(name: "Coffee Shop Link", url: "example.com")
      old_coffee_shop_link_position = coffee_shop_link.position
      links(:political_chapter_become_member).update!(position: 1)

      # The order of the links is reversed
      patch sort_admin_links_path, params: {
        order: [
          links(:political_chapter_become_member).id,
          coffee_shop_link.id,
          links(:political_chapter_our_platform).id
        ]
      }
      assert_response :success

      assert_equal 0, links(:political_chapter_become_member).reload.position

      # No update to the coffee shop link
      assert_equal old_coffee_shop_link_position, coffee_shop_link.reload.position

      # Will still get updated to 2 even when the coffee shop link is unaffected, but that's fine
      assert_equal 2, links(:political_chapter_our_platform).reload.position
    end
  end
end
