class CreateAssessments < ActiveRecord::Migration[8.0]
  def change
    create_table :assessments do |t|
      t.references :membership, null: false, foreign_key: true
      t.integer :value, null: false

      t.timestamps
    end
  end
end
