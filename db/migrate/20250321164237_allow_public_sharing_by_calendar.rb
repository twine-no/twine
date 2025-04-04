class AllowPublicSharingByCalendar < ActiveRecord::Migration[8.0]
  def change
    add_column :meetings, :share_by_calendar, :boolean, default: false, null: false
    rename_column :meetings, :open, :share_by_link
  end
end
