class CreateProjectsAndTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.references :platform, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :tasks do |t|
      t.string :title, null: false
      t.references :project, null: false, foreign_key: true, index: true
      t.boolean :completed, default: false, null: false
      t.timestamps
    end
  end
end
