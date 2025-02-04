class AddNameToRsvps < ActiveRecord::Migration[8.0]
  def change
    add_column :rsvps, :full_name, :string
  end
end
