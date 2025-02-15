require "test_helper"

module Public
  class RsvpsControllerTest < ActionDispatch::IntegrationTest
    test "#new succeeds for open meting" do
      get new_public_rsvp_path(meeting_guid: meetings(:football_club_training).guid)

      assert_response :success
      assert_select "#rsvp-form"
    end

    test "#new succeeds for closed meeting" do
      invite = meetings(:next_political_chapter_board_meeting).invites.create!(membership: memberships(:dave_sits_on_the_political_chapter_board))
      get new_public_rsvp_path(meeting_guid: meetings(:next_political_chapter_board_meeting).guid, invite_guid: invite.guid)

      assert_response :success
      assert_select "#rsvp-form"
    end

    test "#create succeeds for open meeting, creates invite and RSVP" do
      assert_difference -> { meetings(:football_club_training).rsvps.count }, 1 do
        assert_difference -> { meetings(:football_club_training).invites.count }, 1 do
          post public_rsvps_path(meeting_guid: meetings(:football_club_training).guid), params: {
            rsvp: {
              full_name: "Test User",
              email: "test@example.com",
              answer: "yes"
            }
          }
        end
      end

      assert_redirected_to public_event_path(meetings(:football_club_training).guid)
      assert_equal "You're in. You've received a confirmation on test@example.com", flash[:notice]
    end

    test "#create succeeds for closed meeting, if invite is given" do
      invite = meetings(:next_political_chapter_board_meeting).invites.create!(membership: memberships(:dave_sits_on_the_political_chapter_board))

      assert_difference -> { meetings(:next_political_chapter_board_meeting).rsvps.count }, 1 do
        assert_no_difference -> { meetings(:next_political_chapter_board_meeting).invites.count } do
          post public_rsvps_path(
                 meeting_guid: meetings(:next_political_chapter_board_meeting).guid,
                 invite_guid: invite.guid
               ), params: {
            rsvp: {
              email: "test@example.com", # this will be ignored, since an invite with membership is given
              answer: "yes"
            }
          }
        end
      end

      assert_redirected_to public_event_path(meetings(:next_political_chapter_board_meeting).guid, invite_guid: invite.guid)
      assert_equal "You're in. You've received a confirmation on #{invite.contact.email}", flash[:notice]
    end

    test "#create fails for closed meeting, if no invite is given" do
      post public_rsvps_path(meeting_guid: meetings(:next_political_chapter_board_meeting).guid), params: {
        rsvp: {
          full_name: "Jane Doe",
          email: "jane@example.com",
          answer: "yes"
        }
      }

      assert_response :unprocessable_entity
    end
  end
end
