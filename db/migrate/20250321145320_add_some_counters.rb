class AddSomeCounters < ActiveRecord::Migration[8.0]
  def change
    add_column :groups, :memberships_count, :integer, default: 0
    add_column :meetings, :rsvps_count, :integer, default: 0
    add_column :meetings, :rsvps_yes_count, :integer, default: 0
    add_column :meetings, :rsvps_no_count, :integer, default: 0
  end
end
