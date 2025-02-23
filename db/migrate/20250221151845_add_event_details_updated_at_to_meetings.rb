class AddEventDetailsUpdatedAtToMeetings < ActiveRecord::Migration[8.0]
  def change
    add_column :meetings, :happens_at_updated_at, :datetime
    add_column :meetings, :location_updated_at, :datetime
    add_column :meetings, :last_communication_at, :datetime
    add_column :rsvps, :confirmation_sent_at, :datetime
  end
end
