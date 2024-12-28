require "test_helper"

module Admin
  class MembershipsControllerTest < ActionDispatch::IntegrationTest
    test "#index succeeds for admin" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get admin_memberships_path
      assert_response :success
    end

    test "#index returns 404 for member" do
      login_as users(:member), on: platforms(:coffee_shop)
      get admin_memberships_path
      assert_response :not_found
    end

    test "#index redirects to login page if you're not logged in" do
      get admin_memberships_path
      assert_redirected_to new_session_path
    end

    #
    # TABLE BASICS
    #
    test "#index lets you search members by email" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get admin_memberships_path(search_term: users(:dave).email)
      assert_select "td", text: users(:dave).email
      assert_select "td", text: users(:dave).full_name
      assert_select "td", text: users(:admin).email, count: 0
    end

    test "#index lets you search members by full name or just first name or last name" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get admin_memberships_path(search_term: users(:dave).full_name)
      assert_select "td", text: users(:dave).email
      assert_select "td", text: users(:dave).full_name
      assert_select "td", text: users(:admin).email, count: 0

      get admin_memberships_path(search_term: users(:dave).first_name)
      assert_select "td", text: users(:dave).email

      get admin_memberships_path(search_term: users(:dave).last_name)
      assert_select "td", text: users(:dave).email
    end

    test "#index lets you sort members by email and name" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get admin_memberships_path(search_term: users(:dave).full_name)
      assert_select "td", text: users(:dave).email
      assert_select "td", text: users(:dave).full_name
      assert_select "td", text: users(:admin).email, count: 0

      get admin_memberships_path(search_term: users(:dave).first_name)
      assert_select "td", text: users(:dave).email

      get admin_memberships_path(search_term: users(:dave).last_name)
      assert_select "td", text: users(:dave).email
    end

    test "#index lets you make a case-insensitive search for special characters" do
      login_as users(:admin), on: platforms(:coffee_shop)

      users(:dave).update!(first_name: "ÆØÅ")
      get admin_memberships_path(search_term: "æøå")
      assert_select "td", text: users(:dave).email
      assert_select "td", text: users(:dave).full_name
      assert_select "td", text: users(:admin).email, count: 0
    end

    test "#index lets you filter users by roles" do
      login_as users(:admin), on: platforms(:coffee_shop)

      get admin_memberships_path(filters: { "memberships.role": "admin" })
      assert_select ".badge", text: "Admin"
      assert_select ".badge", text: "Member", count: 0

      get admin_memberships_path(filters: { "memberships.role": "member" })
      assert_select ".badge", text: "Member"
      assert_select ".badge", text: "Admin", count: 0
    end

    test "#new succeeds, renders form inside index page, with layout still visible" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get new_admin_membership_path
      assert_select "form#new_membership"
      assert_select "table"
    end

    test "#create succeeds, creates a membership, and redirects with a notice" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_difference -> { Membership.count }, 1 do
        post admin_memberships_path, params: {
          membership: {
            user_attributes: {
              email: "newuser@example.com",
              first_name: "Firstname",
              last_name: "User"
            }
          }
        }
      end
      assert_redirected_to admin_memberships_path
      assert_equal "Invited Firstname", flash[:notice]
    end

    test "#create renders errors when no email is provided, still renders modal and table in background" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_no_difference -> { Membership.count } do
        post admin_memberships_path, params: {
          membership: {
            user_attributes: {
              email: "",
              first_name: "First",
              last_name: "Last"
            }
          }
        }
      end
      assert_response :unprocessable_entity
      assert_select "form#new_membership"
      assert_select "table"
      assert_select ".form-error", text: /Email can't be blank/
    end

    test "#create returns 404 if user tries to associate a Membership with an existing User" do
      login_as users(:admin), on: platforms(:coffee_shop)
      existing_user = users(:dave)

      assert_no_difference -> { Membership.count } do
        assert_no_difference -> { User.count } do
          post admin_memberships_path, params: {
            membership: {
              user_attributes: {
                id: existing_user.id,
                email: "malicious@example.com",
                first_name: "Hacker",
                last_name: "Person"
              }
            }
          }
        end
      end
      assert_response :not_found
    end

    test "#show succeeds" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get admin_membership_path(memberships(:member_owns_a_stake_in_the_coffee_shop))
      assert_response :success
    end

    test "#show returns 404 if membership belongs to a different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get admin_membership_path(memberships(:dave_plays_football))
      assert_response :not_found
    end

    test "#show returns 404 for member users" do
      login_as users(:member), on: platforms(:coffee_shop)
      membership = memberships(:member_owns_a_stake_in_the_coffee_shop)
      get admin_membership_path(membership)
      assert_response :not_found
    end

    test "#edit succeeds for admin" do
      login_as users(:admin), on: platforms(:coffee_shop)
      membership = memberships(:member_owns_a_stake_in_the_coffee_shop)

      get edit_admin_membership_path(membership)
      assert_response :success
      assert_select "form[action=?]", admin_membership_path(membership)
    end

    test "#edit returns 404 if membership belongs to a different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      membership = memberships(:dave_plays_football)

      get edit_admin_membership_path(membership)
      assert_response :not_found
    end

    test "#edit returns 404 for member users" do
      login_as users(:member), on: platforms(:coffee_shop)
      membership = memberships(:member_owns_a_stake_in_the_coffee_shop)

      get edit_admin_membership_path(membership)
      assert_response :not_found
    end

    test "#update succeeds for admin and updates membership" do
      login_as users(:admin), on: platforms(:coffee_shop)
      membership = memberships(:member_owns_a_stake_in_the_coffee_shop)
      new_first_name = "Newbee"

      patch admin_membership_path(membership), params: {
        membership: {
          user_attributes: {
            id: membership.user_id,
            first_name: new_first_name
          }
        }
      }

      assert_redirected_to admin_membership_path(membership)
      assert_equal "Member saved.", flash[:notice]
      membership.reload
      assert_equal new_first_name, membership.user.first_name
    end

    test "#update returns errors when invalid email is submitted" do
      login_as users(:admin), on: platforms(:coffee_shop)
      membership = memberships(:member_owns_a_stake_in_the_coffee_shop)

      patch admin_membership_path(membership), params: {
        membership: {
          id: membership.user_id,
          user_attributes: { email: "" }
        }
      }

      assert_response :unprocessable_entity
      assert_select "form[action=?]", admin_membership_path(membership)
      assert_select ".form-error", text: /Email can't be blank/
    end

    test "#update returns 404 if membership belongs to a different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      membership = memberships(:dave_plays_football)

      patch admin_membership_path(membership), params: {
        membership: {
          id: membership.user_id,
          user_attributes: { first_name: "Newname" }
        }
      }

      assert_response :not_found
    end

    test "#update returns 404 for member users" do
      login_as users(:member), on: platforms(:coffee_shop)
      membership = memberships(:member_owns_a_stake_in_the_coffee_shop)

      patch admin_membership_path(membership), params: {
        membership: {
          id: membership.user_id,
          user_attributes: { first_name: "Newname" }
        }
      }

      assert_response :not_found
    end

    test "#update does not allow changing the associated user" do
      login_as users(:admin), on: platforms(:coffee_shop)
      membership = memberships(:member_owns_a_stake_in_the_coffee_shop)
      other_user = users(:dave)

      assert_no_changes -> { membership.reload.user_id } do
        patch admin_membership_path(membership), params: {
          membership: {
            user_attributes: {
              id: other_user.id,
              email: "hacker@example.com",
              first_name: "Hacker",
              last_name: "Person"
            }
          }
        }
      end
      assert_response :not_found
    end

    test "#update does not allow you to create a new User by not passing a user id" do
      login_as users(:admin), on: platforms(:coffee_shop)
      membership = memberships(:member_owns_a_stake_in_the_coffee_shop)

      assert_no_changes -> { membership.user_id } do
        assert_no_changes -> { User.count } do
          patch admin_membership_path(membership), params: {
            membership: {
              user_attributes: {
                email: "hacker@example.com",
                first_name: "Hacker",
                last_name: "Person"
              }
            }
          }
        end
      end
      assert_response :unprocessable_content
    end

    test "#update lets super admin update membership role" do
      login_as users(:super_admin), on: platforms(:coffee_shop)
      membership = memberships(:member_owns_a_stake_in_the_coffee_shop)

      patch admin_membership_path(membership), params: {
        membership: {
          role: "admin"
        }
      }

      assert membership.reload.admin?
    end

    test "#update does not let regular admin update membership role" do
      login_as users(:admin), on: platforms(:coffee_shop)
      membership = memberships(:member_owns_a_stake_in_the_coffee_shop)

      patch admin_membership_path(membership), params: {
        membership: {
          role: "admin"
        }
      }

      assert membership.reload.member?
    end

    test "#update does not let user update their own role" do
      login_as users(:super_admin), on: platforms(:coffee_shop)
      membership = users(:super_admin).memberships.find_by!(platform: platforms(:coffee_shop))

      patch admin_membership_path(membership), params: {
        membership: {
          role: "admin"
        }
      }

      assert membership.reload.super_admin?
    end

    test "#destroy succeeds for admin, deletes membership and redirects to members list" do
      login_as users(:admin), on: platforms(:coffee_shop)
      membership = memberships(:member_owns_a_stake_in_the_coffee_shop)

      assert_difference -> { Membership.count }, -1 do
        delete admin_membership_path(membership)
      end

      assert_redirected_to admin_memberships_path
      assert_equal "Deleted #{memberships(:member_owns_a_stake_in_the_coffee_shop).user.full_name}", flash[:notice]
    end

    test "#destroy returns 404 if membership belongs to a different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      membership = memberships(:dave_plays_football)

      assert_no_difference -> { Membership.count } do
        delete admin_membership_path(membership)
      end

      assert_response :not_found
    end

    test "#destroy returns 404 for member users" do
      login_as users(:member), on: platforms(:coffee_shop)
      membership = memberships(:member_owns_a_stake_in_the_coffee_shop)

      assert_no_difference -> { Membership.count } do
        delete admin_membership_path(membership)
      end

      assert_response :not_found
    end

    test "#destroy does not let you delete yourself" do
      login_as users(:admin), on: platforms(:coffee_shop)
      admin_membership = users(:admin).memberships.find_by!(platform: platforms(:coffee_shop))

      assert_no_difference -> { Membership.count } do
        delete admin_membership_path(admin_membership)
      end

      assert_redirected_to admin_membership_path(admin_membership)
      assert_equal "You can't delete yourself!", flash[:notice]
    end
  end
end
