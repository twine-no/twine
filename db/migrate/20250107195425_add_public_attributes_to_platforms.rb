class AddPublicAttributesToPlatforms < ActiveRecord::Migration[8.0]
  def change
    add_column :platforms, :shortname, :string
    add_column :platforms, :listed, :boolean

    add_index :platforms, :shortname, unique: true
  end
end
