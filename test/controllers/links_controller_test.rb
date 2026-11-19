require "test_helper"

class LinksControllerTest < ActionDispatch::IntegrationTest
  test "#create succeeds" do
    login_as users(:me)
    assert_difference -> { pages(:bakery).links.count } do
      post links_path, params: { link: { name: "Instagram", url: "instagram.com/springbakery" } }
    end
    assert_redirected_to edit_page_path

    assert_equal "Instagram", pages(:bakery).links.last.name
    assert_equal "https://instagram.com/springbakery", pages(:bakery).links.last.url
    assert_equal links(:bakery_menu).position + 1, pages(:bakery).links.last.position
  end

  test "#create refuses an address that would run a script" do
    login_as users(:me)
    assert_no_difference -> { Link.count } do
      post links_path, params: { link: { name: "Click me", url: "javascript:alert(1)" } }
    end
    assert_redirected_to edit_page_path
    assert_equal "Address must be a web address or an email address", flash[:alert]
  end

  test "#create is only accessible when logged in" do
    assert_no_difference -> { Link.count } do
      post links_path, params: { link: { name: "Instagram", url: "instagram.com/springbakery" } }
    end
    assert_redirected_to new_session_path
  end

  test "#update succeeds" do
    login_as users(:me)
    patch link_path(links(:bakery_menu)), params: { link: { name: "Menu", url: "springbakery.example/new-menu" } }
    assert_redirected_to edit_page_path

    assert_equal "Menu", links(:bakery_menu).reload.name
    assert_equal "https://springbakery.example/new-menu", links(:bakery_menu).url
  end

  test "#update is not possible for a link on somebody else's page" do
    login_as users(:me)
    assert_no_changes -> { links(:political_chapter_become_a_member).reload.name } do
      patch link_path(links(:political_chapter_become_a_member)), params: { link: { name: "Hijacked" } }
    end
    assert_response :not_found
  end

  test "#destroy succeeds" do
    login_as users(:me)
    assert_difference -> { pages(:bakery).links.count }, -1 do
      delete link_path(links(:bakery_menu))
    end
    assert_redirected_to edit_page_path
  end

  test "#destroy is not possible for a link on somebody else's page" do
    login_as users(:me)
    assert_no_difference -> { Link.count } do
      delete link_path(links(:political_chapter_become_a_member))
    end
    assert_response :not_found
  end
end
