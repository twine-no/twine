require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  test "#reset succeeds" do
    user = users(:dave)

    email = PasswordsMailer.reset(user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "hey@twine.no" ], email.from
    assert_equal [ user.email ], email.to
    assert_equal "Reset your password", email.subject
    assert_match "reset your password", email.body.to_s
  end
end
