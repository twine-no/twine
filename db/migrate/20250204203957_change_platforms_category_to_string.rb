class ChangePlatformsCategoryToString < ActiveRecord::Migration[8.0]
  def change
    remove_column :platforms, :category, :integer, null: false
    add_column :platforms, :category, :string, null: false, default: "unorganised"
  end
end
