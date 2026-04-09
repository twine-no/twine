class MoveFeelingFromProjectsToPlatforms < ActiveRecord::Migration[8.0]
  def change
    remove_column :projects, :feeling, :integer
    add_column :platforms, :feeling, :integer
  end
end
