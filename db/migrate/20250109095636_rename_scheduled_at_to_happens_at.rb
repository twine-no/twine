class RenameScheduledAtToHappensAt < ActiveRecord::Migration[8.0]
  def change
    rename_column :meetings, :scheduled_at, :happens_at
  end
end
