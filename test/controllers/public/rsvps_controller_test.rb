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
      assert_equal "You're in. We sent a confirmation to test@example.com", flash[:notice]
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
      assert_equal "You're in. We sent a confirmation to #{invite.contact.email}", flash[:notice]
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

    test "#create does not change existing RSVP" do
      invite = meetings(:football_club_training).invites.create!
      Rsvp.create!(invite: invite, meeting: invite.meeting, answer: :yes, email: "test@example.com", full_name: "Test User")
      assert_no_difference -> { meetings(:football_club_training).rsvps.count } do
        assert_no_difference -> { meetings(:football_club_training).invites.count } do
          post public_rsvps_path(meeting_guid: meetings(:football_club_training).guid), params: {
            rsvp: {
              full_name: "Doesnt Matter if its different",
              email: "test@example.com",
              answer: "yes"
            }
          }
        end
      end

      assert_redirected_to public_event_path(meetings(:football_club_training).guid)
      assert_equal "Already signed up. Edit your response from the link in your confirmation email", flash[:notice]
    end

    test "#create sends confirmation email to the right recipient" do
      assert_emails 1 do
        post public_rsvps_path(meeting_guid: meetings(:football_club_training).guid), params: {
          rsvp: {
            full_name: "Test User",
            email: "test@example.com",
            answer: "yes"
          }
        }
      end

      mail = ActionMailer::Base.deliveries.last
      assert_equal [ "test@example.com" ], mail.to
      assert_includes mail.subject, meetings(:football_club_training).title
    end

    test "#create does not send confirmation email if user RSVPs no" do
      assert_no_emails do
        post public_rsvps_path(meeting_guid: meetings(:football_club_training).guid), params: {
          rsvp: {
            full_name: "Test User",
            email: "test@example.com",
            answer: "no"
          }
        }
      end
    end

    test "#edit succeeds" do
      invite = meetings(:football_club_training).invites.create!(membership: memberships(:dave_plays_football))
      rsvp = Rsvp.create!(invite: invite, meeting: invite.meeting, answer: :yes)

      get edit_public_rsvp_path(rsvp, meeting_guid: meetings(:football_club_training).guid)
      assert_response :success
    end

    test "#update lets guest update RSVP details" do
      invite = meetings(:football_club_training).invites.create!(membership: memberships(:dave_plays_football))
      rsvp = Rsvp.create!(invite: invite, meeting: invite.meeting, answer: :yes)

      patch public_rsvp_path(rsvp, meeting_guid: meetings(:football_club_training).guid), params: {
        rsvp: {
          answer: "yes",
          full_name: "New name",
          email: "newmail2@mail.com"
        }
      }

      rsvp.reload
      assert_equal "New name", rsvp.full_name
      assert_equal "newmail2@mail.com", rsvp.email
    end

    test "#update does not let you update RSVP for different meeting" do
      invite = meetings(:football_club_training).invites.create!(membership: memberships(:dave_plays_football))
      rsvp = Rsvp.create!(invite: invite, meeting: invite.meeting, answer: :yes)

      assert_no_changes -> { rsvp.reload.full_name } do
        assert_no_changes -> { rsvp.reload.email } do
          patch public_rsvp_path(rsvp, meeting_guid: meetings(:next_coffee_shop_board_meeting).guid), params: {
            rsvp: {
              answer: "yes",
              full_name: "New name",
              email: "newmail2@mail.com"
            }
          }
        end
      end
    end

    test "#update sends new confirmation email if RSVP answer is yes" do
      invite = meetings(:football_club_training).invites.create!(membership: memberships(:dave_plays_football))
      rsvp = Rsvp.create!(invite: invite, meeting: invite.meeting, answer: :yes)

      assert_emails 1 do
        patch public_rsvp_path(rsvp, meeting_guid: meetings(:football_club_training).guid), params: {
          rsvp: {
            answer: "yes",
            full_name: "New name",
            email: "newmail2@mail.com"
          }
        }
      end
    end

    test "#update does not send confirmation email if RSVP answer is no" do
      invite = meetings(:football_club_training).invites.create!(membership: memberships(:dave_plays_football))
      rsvp = Rsvp.create!(invite: invite, meeting: invite.meeting, answer: :yes)

      assert_no_emails do
        patch public_rsvp_path(rsvp, meeting_guid: meetings(:football_club_training).guid), params: {
          rsvp: {
            answer: "no",
            full_name: "New name",
            email: "newmail2@mail.com"
          }
        }
      end
    end
  end
end
