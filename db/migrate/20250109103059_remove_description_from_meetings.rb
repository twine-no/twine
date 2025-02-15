class RemoveDescriptionFromMeetings < ActiveRecord::Migration[8.0]
  def change
    remove_column :meetings, :description, :text
  end
end
