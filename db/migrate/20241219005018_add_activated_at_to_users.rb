class AddActivatedAtToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :registered_at, :datetime
  end
end
