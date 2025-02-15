class AddTaglineToPlatforms < ActiveRecord::Migration[8.0]
  def change
    add_column :platforms, :tagline, :string
  end
end
