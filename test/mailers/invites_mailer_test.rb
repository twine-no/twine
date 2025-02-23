require "test_helper"

class InvitesMailertest < ActionMailer::TestCase
  test "#send_message succeeds" do
    invite = Invite.create(
      meeting: meetings(:coffee_shop_general_assembly),
      membership: memberships(:dave_is_a_coffee_shop_shareholder)
    )

    message = invite.messages.create!(
      content: "Hi everyone, here's some info about the GA (…).",
      category: :email
    )
    mail = InvitesMailer.send_message(message)
    assert_match "Invite to General Assembly", mail.subject
    assert_equal [ memberships(:dave_is_a_coffee_shop_shareholder).user.email ], mail.to
    assert_equal [ "hey@twine.no" ], mail.from
    assert_match message.content.to_plain_text, mail.body.encoded
  end
end
