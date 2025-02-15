class CreateRsvps < ActiveRecord::Migration[8.0]
  def change
    create_table :rsvps do |t|
      t.references :invite, index: true, foreign_key: true, null: false
      t.string :answer, index: true, null: false

      t.timestamps
    end
  end
end
