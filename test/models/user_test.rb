require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#save saves valid member" do
    user = User.new(
      first_name: "User",
      last_name: "Userson",
      email: "user.userson@email.com",
      password: "password123"
    )
    assert user.save
  end

  test "#save prevents saving User without email" do
    user = User.new(
      first_name: "User",
      last_name: "Userson",
      password: "password123"
    )
    assert_not user.save

    # Doesn't work either
    user.email = ""
    assert_not user.save
  end
end
