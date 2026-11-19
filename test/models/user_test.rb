require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#save succeeds with an email and a password" do
    assert User.new(email: " Astrid@Example.com ", password: "password123").save
    assert User.exists?(email: "astrid@example.com")
  end

  test "#save fails without an email" do
    assert_not User.new(email: "", password: "password123").save
  end

  test "#save fails with a password shorter than 8 characters" do
    assert_not User.new(email: "astrid@example.com", password: "short").save
  end
end
