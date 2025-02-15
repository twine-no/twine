require "test_helper"

class MeetingLogEntryTest < ActiveSupport::TestCase
  test "#save succeeds" do
    log_entry = meetings(:next_coffee_shop_board_meeting).log_entries.new(category: :created, happened_at: Time.current)
    assert log_entry.save
  end

  test "#validations require a category to be set" do
    log_entry = meetings(:next_coffee_shop_board_meeting).log_entries.new(category: nil, happened_at: Time.current)
    assert_not log_entry.save
  end

  test "#validations require a happened_at date to be set" do
    log_entry = meetings(:next_coffee_shop_board_meeting).log_entries.new(category: :created, happened_at: nil)
    assert_not log_entry.save
  end
end
