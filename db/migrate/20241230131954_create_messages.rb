class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :messageable, polymorphic: true, null: false, index: true
      t.string :category, null: false

      t.text :content

      t.timestamps
    end
  end
end
