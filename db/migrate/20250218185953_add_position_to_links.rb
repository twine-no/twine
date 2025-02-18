class AddPositionToLinks < ActiveRecord::Migration[8.0]
  def change
    add_column :links, :position, :integer, default: 0
  end
end
