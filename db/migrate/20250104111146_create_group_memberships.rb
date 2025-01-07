class CreateGroupMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :groups_memberships, id: false do |t|
      t.belongs_to :group
      t.belongs_to :membership

      t.timestamps
    end

    add_index :groups_memberships, [ :group_id, :membership_id ], unique: true
  end
end
