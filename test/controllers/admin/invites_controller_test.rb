require "test_helper"

module Admin
  class InvitesControllerTest < ActionDispatch::IntegrationTest
    test "#create lets an admin add a guest to the event" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_difference -> { meetings(:next_coffee_shop_board_meeting).invites.count }, 1 do
        post admin_meeting_invites_path(
               meetings(:next_coffee_shop_board_meeting)),
             params: {
               invite: { membership_id: memberships(:dave_is_a_coffee_shop_shareholder).id }
             }
        assert_redirected_to admin_meeting_path(meetings(:next_coffee_shop_board_meeting))
      end
    end

    test "#create does not let you invite a Membership from another Platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_no_difference -> { meetings(:football_club_training).invites.count } do
        post admin_meeting_invites_path(
               meetings(:football_club_training)),
             params: {
               invite: { membership_id: memberships(:dave_is_a_coffee_shop_shareholder).id }
             }
        assert_response :not_found
      end
    end

    test "#create does not let you invite a Membership to another Platform's Meeting" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_no_difference -> { meetings(:next_coffee_shop_board_meeting).invites.count } do
        post admin_meeting_invites_path(
               meetings(:next_coffee_shop_board_meeting)),
             params: {
               invite: { membership_id: memberships(:dave_plays_football).id }
             }
        assert_response :unprocessable_content
      end
    end

    test "#show lets an admin view an invite they've sent" do
      login_as users(:admin), on: platforms(:coffee_shop)
      invite = meetings(:next_coffee_shop_board_meeting).invites.create(membership_id: memberships(:dave_is_a_coffee_shop_shareholder).id)
      get admin_meeting_invite_path(
            invite.meeting,
            invite)
      assert_response :success

      # Email field shows, with User's email filled out, but it's not editable
      assert_select "input[type='email'][disabled][value='#{memberships(:dave_is_a_coffee_shop_shareholder).user.email}']"
    end

    test "#show lets an admin view an invite the user created through a public link" do
      login_as users(:admin), on: platforms(:coffee_shop)
      invite = meetings(:next_coffee_shop_board_meeting).invites.create!
      meetings(:next_coffee_shop_board_meeting).rsvps.create!(
        invite: invite,
        answer: :yes,
        email: "someemail@mail.com",
        full_name: "Self Signup Guy"
      )
      get admin_meeting_invite_path(
            invite.meeting,
            invite)
      assert_response :success
    end

    test "#destroy lets an admin remove an invite they've sent" do
      login_as users(:admin), on: platforms(:coffee_shop)
      invite = meetings(:next_coffee_shop_board_meeting).invites.create(membership_id: memberships(:dave_is_a_coffee_shop_shareholder).id)
      assert_difference -> { meetings(:next_coffee_shop_board_meeting).invites.count }, -1 do
        delete admin_meeting_invite_path(
                 invite.meeting,
                 invite)
        assert_redirected_to admin_meeting_path(meetings(:next_coffee_shop_board_meeting))
      end
    end

    test "#destroy does not let you remove an invite from another Platform's Meeting" do
      login_as users(:admin), on: platforms(:coffee_shop)
      invite = meetings(:football_club_training).invites.create(membership_id: memberships(:dave_plays_football).id)
      assert_no_difference -> { meetings(:football_club_training).invites.count } do
        delete admin_meeting_invite_path(
                 invite.meeting,
                 invite)
        assert_response :not_found
      end
    end
  end
end
