class CreateMeetings < ActiveRecord::Migration[8.0]
  def change
    create_table :meetings do |t|
      t.references :platform, null: false, foreign_key: true, index: true
      t.string :title, null: false
      t.datetime :scheduled_at, null: false

      t.timestamps
    end
  end
end
