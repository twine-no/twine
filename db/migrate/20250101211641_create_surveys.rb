class CreateSurveys < ActiveRecord::Migration[8.0]
  def change
    create_table :surveys do |t|
      t.references :meeting, null: false, index: true
      t.string :guid
      t.boolean :open, null: false, default: false

      t.timestamps
    end

    add_index :surveys, :guid, unique: true

    create_table :surveys_questions do |t|
      t.references :survey, null: false, index: true
      t.string :title
      t.string :category, null: false

      t.timestamps
    end

    create_table :surveys_alternatives do |t|
      t.references :question, null: false, index: true
      t.string :title

      t.timestamps
    end

    create_table :surveys_answers do |t|
      t.references :question, null: false, index: true
      t.references :alternative, index: true
      t.string :answer

      t.timestamps
    end
  end
end
