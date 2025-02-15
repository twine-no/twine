class RemoveMembershipConstraintFromInvites < ActiveRecord::Migration[8.0]
  def change
    change_column_null :invites, :membership_id, true
  end
end
