require "test_helper"

module Public
  class MeetingsControllerTest < ActionDispatch::IntegrationTest
    test "#show succeeds for open meeting with no invite" do
      get public_event_path(meetings(:football_club_training).guid)
      assert_response :success

      # User signs up if they want to join
      assert_select "#sign-up-button", count: 1
      assert_select "#yes-rsvp-button", count: 0
      assert_select "#no-rsvp-button", count: 0
    end

    test "#show succeeds for open meeting with invite" do
      invite = meetings(:football_club_training).invites.create!(membership: memberships(:dave_plays_football))
      get public_event_path(meetings(:football_club_training).guid, invite_guid: invite.guid)
      assert_response :success

      # User answers the invite with yes or no
      assert_select "#sign-up-button", count: 0
      assert_select "#yes-rsvp-button", count: 1
      assert_select "#no-rsvp-button", count: 1
    end

    test "#show succeeds for open meeting with yes RSVP already given" do
      invite = meetings(:football_club_training).invites.create!(membership: memberships(:dave_plays_football))
      meetings(:football_club_training).rsvps.create!(invite: invite, answer: :yes)
      get public_event_path(meetings(:football_club_training).guid, invite_guid: invite.guid)
      assert_response :success

      # The user has a single button to change their answer
      assert_select "#sign-up-button", count: 1
      assert_select "#yes-rsvp-button", count: 0
      assert_select "#no-rsvp-button", count: 0
      assert_select "a", "✅ You accepted (change)"
    end

    test "#show succeeds for open meeting with no RSVP already given" do
      invite = meetings(:football_club_training).invites.create!(membership: memberships(:dave_plays_football))
      meetings(:football_club_training).rsvps.create!(invite: invite, answer: :no)
      get public_event_path(meetings(:football_club_training).guid, invite_guid: invite.guid)
      assert_response :success

      # The user has a single button to change their answer
      assert_select "#sign-up-button", count: 1
      assert_select "#yes-rsvp-button", count: 0
      assert_select "#no-rsvp-button", count: 0
      assert_select "a", "❌ You declined (change)"
    end

    test "#show also stores the invite GUID in a cookie, in case you return to the meeting page with no invite GUID" do
      invite = meetings(:football_club_training).invites.create!(membership: memberships(:dave_plays_football))
      meetings(:football_club_training).rsvps.create!(invite: invite, answer: :yes)

      # invite not in the URL, but in a cookie
      cookies["#{meetings(:football_club_training).guid}_invite_guid"] = invite.guid
      get public_event_path(meetings(:football_club_training).guid)
      assert_response :success

      # The user has a single button to change their answer
      assert_select "#sign-up-button", count: 1
      assert_select "#yes-rsvp-button", count: 0
      assert_select "#no-rsvp-button", count: 0
      assert_select "a", "✅ You accepted (change)"
    end

    test "#show succeeds for private meeting with invite" do
      invite = meetings(:next_political_chapter_board_meeting).invites.create!(membership: memberships(:dave_sits_on_the_political_chapter_board))
      get public_event_path(meetings(:next_political_chapter_board_meeting).guid, invite_guid: invite.guid)
      assert_response :success

      # User answers the invite with yes or no
      assert_select "#sign-up-button", count: 0
      assert_select "#yes-rsvp-button", count: 1
      assert_select "#no-rsvp-button", count: 1
    end

    test "#show succeeds for private meeting with invite and survey" do
      meetings(:next_political_chapter_board_meeting).surveys.create!(template: :meeting_date)
      invite = meetings(:next_political_chapter_board_meeting).invites.create!(membership: memberships(:dave_sits_on_the_political_chapter_board))
      get public_event_path(meetings(:next_political_chapter_board_meeting).guid, invite_guid: invite.guid)
      assert_response :success

      # User answers by signing up out and filling out their info, or declining
      assert_select "#sign-up-button", count: 1
      assert_select "#yes-rsvp-button", count: 0
      assert_select "#no-rsvp-button", count: 1
    end

    test "#show succeeds for private meeting with invite and rsvp already given" do
      invite = meetings(:next_political_chapter_board_meeting).invites.create!(membership: memberships(:dave_sits_on_the_political_chapter_board))
      meetings(:football_club_training).rsvps.create!(invite: invite, answer: :yes)
      get public_event_path(meetings(:next_political_chapter_board_meeting).guid, invite_guid: invite.guid)
      assert_response :success

      # The user has a single button to change their answer
      assert_select "#sign-up-button", count: 1
      assert_select "#yes-rsvp-button", count: 0
      assert_select "#no-rsvp-button", count: 0
      assert_select "a", "✅ You accepted (change)"
    end

    test "#show selects invite by invite_guid if set, even if cookie is also set" do
      invite = meetings(:next_political_chapter_board_meeting).invites.create!(membership: memberships(:dave_sits_on_the_political_chapter_board))
      other_invite = meetings(:next_political_chapter_board_meeting).invites.create!(membership: memberships(:you_sit_on_the_political_chapter_board))
      meetings(:next_political_chapter_board_meeting).rsvps.create!(invite: other_invite, answer: :yes)

      cookies["#{meetings(:football_club_training).guid}_invite_guid"] = other_invite.guid

      get public_event_path(meetings(:next_political_chapter_board_meeting).guid, invite_guid: invite.guid)
      assert_response :success

      # User answers the invite with yes or no. Invite guid stored in cookie ignored
      assert_select "#sign-up-button", count: 0
      assert_select "#yes-rsvp-button", count: 1
      assert_select "#no-rsvp-button", count: 1
    end

    test "#show returns 404 for private meeting with no invite" do
      get public_event_path(meetings(:next_political_chapter_board_meeting).guid)
      assert_response :not_found
    end

    test "#show returns 404 for private meeting with invite to wrong meeting" do
      invite_to_other_meeting = meetings(:next_coffee_shop_board_meeting).invites.create!(membership: memberships(:dave_is_a_coffee_shop_shareholder))
      get public_event_path(meetings(:next_political_chapter_board_meeting).guid, invite_guid: invite_to_other_meeting.guid)
      assert_response :not_found
    end
  end
end
