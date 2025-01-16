class AddEmailToRsvps < ActiveRecord::Migration[8.0]
  def change
    add_column :rsvps, :email, :string
  end
end
