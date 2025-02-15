class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.references :platform, index: true, null: false

      t.timestamps
    end
  end
end
