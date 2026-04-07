class AddPositionToMemberships < ActiveRecord::Migration[8.0]
  def up
    add_column :memberships, :position, :integer

    User.find_each do |user|
      user.memberships.order(:created_at).each_with_index do |membership, index|
        membership.update_column(:position, index)
      end
    end
  end

  def down
    remove_column :memberships, :position
  end
end
