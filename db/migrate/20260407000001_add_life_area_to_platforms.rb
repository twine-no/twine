class AddLifeAreaToPlatforms < ActiveRecord::Migration[8.0]
  def change
    add_column :platforms, :life_area, :string, default: "work", null: false
  end
end
