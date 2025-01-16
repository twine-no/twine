class AddGuidToInvites < ActiveRecord::Migration[8.0]
  def change
    add_column :invites, :guid, :string
  end
end
