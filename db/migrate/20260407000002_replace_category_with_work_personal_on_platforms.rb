class ReplaceCategoryWithWorkPersonalOnPlatforms < ActiveRecord::Migration[8.0]
  def change
    remove_column :platforms, :category, :string, null: false, default: "unorganised"
    rename_column :platforms, :life_area, :category
  end
end
