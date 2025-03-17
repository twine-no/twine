require "test_helper"

class MeetingTest < ActiveSupport::TestCase
  test "#save should update location_updated_at only when location is updated" do
    assert_changes -> { meetings(:previous_coffee_shop_board_meeting).location_updated_at } do
      meetings(:previous_coffee_shop_board_meeting).update!(location: "New Location")
    end

    assert_no_changes -> { meetings(:previous_coffee_shop_board_meeting).location_updated_at } do
      meetings(:previous_coffee_shop_board_meeting).update!(starts_at: Time.current + 1.day)
    end
  end

  test "#save should update starts_at_updated_at when happens_at is updated" do
    assert_changes -> { meetings(:previous_coffee_shop_board_meeting).starts_at_updated_at } do
      meetings(:previous_coffee_shop_board_meeting).update!(starts_at: Time.current + 1.day)
    end

    assert_no_changes -> { meetings(:previous_coffee_shop_board_meeting).starts_at_updated_at } do
      meetings(:previous_coffee_shop_board_meeting).update!(location: "New Location")
    end
  end
end
