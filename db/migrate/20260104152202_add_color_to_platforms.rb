class AddColorToPlatforms < ActiveRecord::Migration[8.0]
  def change
    add_column :platforms, :color, :string
  end
end
