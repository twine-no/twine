require "test_helper"

class MeetingTest < ActiveSupport::TestCase
  test "#by_table_tab allows you to filter meetings by whether they're upcoming or not" do
    meetings = Meeting.by_table_tab("past")
    assert meetings.all?(&:past?)
  end

  test "#by_table_tab defaults to only showing upcoming meetings" do
    meetings = Meeting.by_table_tab(nil)
    assert meetings.all?(&:upcoming?)
  end
end
