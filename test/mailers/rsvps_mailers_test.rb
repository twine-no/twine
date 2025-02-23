require "test_helper"

class RsvpsMailersTest < ActionMailer::TestCase
  setup do
    invite = meetings(:previous_coffee_shop_board_meeting).invites.create!(membership: memberships(:eve_is_a_coffee_shop_shareholder))
    @rsvp = Rsvp.create!(invite: invite, answer: :yes, meeting: invite.meeting)
  end

  test "#confirmation sets confirmation_sent_at" do
    assert_changes -> { @rsvp.confirmation_sent_at } do
      RsvpsMailer.confirmation(@rsvp).deliver_now
    end
  end

  test "#confirmation includes an .ics attachment if a date has been set" do
    meetings(:previous_coffee_shop_board_meeting).update!(happens_at: Time.current)
    mail = RsvpsMailer.confirmation(@rsvp)
    assert_equal 1, mail.attachments.count
  end

  test "#confirmation doesn't include .ics attachment if date hasn't been set" do
    meetings(:previous_coffee_shop_board_meeting).update!(happens_at: nil)
    mail = RsvpsMailer.confirmation(@rsvp)
    assert_equal 0, mail.attachments.count
  end

  test "#updated_confirmation sets confirmation_sent_at" do
    assert_changes -> { @rsvp.confirmation_sent_at } do
      RsvpsMailer.updated_confirmation(@rsvp, [ "date", "location" ]).deliver_now
    end
  end

  test "#updated_confirmation includes an .ics attachment if a date has been set" do
    meetings(:previous_coffee_shop_board_meeting).update!(happens_at: Time.current)
    mail = RsvpsMailer.updated_confirmation(@rsvp, [ "date", "location" ])
    assert_equal 1, mail.attachments.count
  end

  test "#updated_confirmation doesn't include .ics attachment if date hasn't been set" do
    meetings(:previous_coffee_shop_board_meeting).update!(happens_at: nil)
    mail = RsvpsMailer.updated_confirmation(@rsvp, [ "date", "location" ])
    assert_equal 0, mail.attachments.count
  end
end
