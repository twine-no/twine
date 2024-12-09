class CreateBasicTableStructure < ActiveRecord::Migration[8.0]
  def change
    create_table :platforms do |t|
      t.string :name, null: false
      t.integer :category, null: false, default: 0
    end

    create_table :memberships do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :platform, index: true, foreign_key: true, null: false
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
