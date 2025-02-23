require "test_helper"

module Admin
  class ResendConfirmationsControllerTest < ActionDispatch::IntegrationTest
    test "#create lets an admin send new confirmation emails to invited users when date has changed" do
      login_as users(:admin), on: platforms(:coffee_shop)

      invite = meetings(:next_coffee_shop_board_meeting).invites.create!(
        membership: memberships(:dave_is_a_coffee_shop_shareholder)
      )
      rsvp = meetings(:next_coffee_shop_board_meeting).rsvps.create!(
        invite: invite,
        answer: "yes",
        confirmation_sent_at: 2.minutes.ago
      )

      # Meeting date is updated after rsvp is created
      meetings(:next_coffee_shop_board_meeting).update!(happens_at: 2.days.from_now)

      assert_emails 1 do
        post admin_meeting_resend_confirmations_path(meetings(:next_coffee_shop_board_meeting))
        assert_redirected_to admin_meeting_path(meetings(:next_coffee_shop_board_meeting))
      end

      mail = ActionMailer::Base.deliveries.last
      assert_equal [ rsvp.invite.contact.email ], mail.to

      # Confirmation timestamp updated
      rsvp.reload
      assert rsvp.confirmation_sent_at > 1.minute.ago
    end

    test "#create lets an admin send new confirmation emails to invited users when location has changed" do
      login_as users(:admin), on: platforms(:coffee_shop)

      invite = meetings(:next_coffee_shop_board_meeting).invites.create!(
        membership: memberships(:dave_is_a_coffee_shop_shareholder)
      )
      rsvp = meetings(:next_coffee_shop_board_meeting).rsvps.create!(
        invite: invite,
        answer: "yes",
        confirmation_sent_at: 2.minutes.ago
      )

      # Meeting date is updated after rsvp is created
      meetings(:next_coffee_shop_board_meeting).update!(location: "New location")

      assert_emails 1 do
        post admin_meeting_resend_confirmations_path(meetings(:next_coffee_shop_board_meeting))
        assert_redirected_to admin_meeting_path(meetings(:next_coffee_shop_board_meeting))
      end

      mail = ActionMailer::Base.deliveries.last
      assert_equal [ rsvp.invite.contact.email ], mail.to

      # Confirmation timestamp updated
      rsvp.reload
      assert rsvp.confirmation_sent_at > 1.minute.ago
    end

    test "#create does not resend confirmation to users who already have an up-to-date-invitation" do
      login_as users(:admin), on: platforms(:coffee_shop)

      # Meeting date is updated after rsvp is created
      meetings(:next_coffee_shop_board_meeting).update!(happens_at: 2.days.from_now)

      invite = meetings(:next_coffee_shop_board_meeting).invites.create!(
        membership: memberships(:dave_is_a_coffee_shop_shareholder)
      )
      confirmation_sent_at = Time.current
      rsvp = meetings(:next_coffee_shop_board_meeting).rsvps.create!(
        invite: invite,
        answer: "yes",
        confirmation_sent_at: confirmation_sent_at
      )

      assert_no_changes -> { rsvp.reload.confirmation_sent_at } do
        assert_emails 0 do
          post admin_meeting_resend_confirmations_path(meetings(:next_coffee_shop_board_meeting))
          assert_redirected_to admin_meeting_path(meetings(:next_coffee_shop_board_meeting))
        end
      end
    end
  end
end
