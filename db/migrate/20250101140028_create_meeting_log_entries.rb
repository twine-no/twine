class CreateMeetingLogEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :meeting_log_entries do |t|
      t.datetime :happened_at, null: false
      t.string :category, null: false
      t.references :meeting, null: false, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
