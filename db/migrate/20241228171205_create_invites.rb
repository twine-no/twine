class CreateInvites < ActiveRecord::Migration[8.0]
  def change
    create_table :invites do |t|
      t.references :meeting, index: true, foreign_key: true, null: false
      t.references :membership, index: true, foreign_key: true, null: false

      t.timestamps
    end

    add_index :invites, [ :meeting_id, :membership_id ], unique: true
  end
end
