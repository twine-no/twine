class AddGuidToRsvps < ActiveRecord::Migration[8.0]
  def change
    add_column :rsvps, :guid, :string, null: false
    add_index :rsvps, :guid, unique: true
    add_index :invites, :guid, unique: true
    change_column_null :invites, :guid, false
  end
end
