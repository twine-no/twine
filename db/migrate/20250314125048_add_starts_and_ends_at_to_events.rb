class AddStartsAndEndsAtToEvents < ActiveRecord::Migration[8.0]
  def change
    rename_column :meetings, :happens_at, :starts_at
    rename_column :meetings, :happens_at_updated_at, :starts_at_updated_at
    add_column :meetings, :ends_at, :datetime
  end
end
