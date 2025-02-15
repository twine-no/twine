class AddGuidToMeetings < ActiveRecord::Migration[8.0]
  def change
    add_column :meetings, :guid, :string
    add_index :meetings, :guid, unique: true
  end
end
