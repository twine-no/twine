class AddCalendarTagLineToPlatforms < ActiveRecord::Migration[8.0]
  def change
    add_column :platforms, :calendar_tagline, :string
  end
end
