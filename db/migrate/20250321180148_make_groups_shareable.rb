class MakeGroupsShareable < ActiveRecord::Migration[8.0]
  def change
    add_column :groups, :share_by_calendar, :boolean, default: false, null: false
    add_column :groups, :share_by_link, :boolean, default: false, null: false
    add_column :groups, :guid, :string
    add_index :groups, :guid, unique: true
  end
end
