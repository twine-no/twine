class AddMeetingToRsvps < ActiveRecord::Migration[8.0]
  def change
    add_reference :rsvps, :meeting, index: true, null: false
    change_column_null :rsvps, :invite_id, true
  end
end
