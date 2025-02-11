class MakeResponseAlternativeManyToMany < ActiveRecord::Migration[8.0]
  def change
    create_table :surveys_alternatives_responses, id: false do |t|
      t.references :response, null: false, foreign_key: { to_table: :surveys_responses }
      t.references :alternative, null: false, foreign_key: { to_table: :surveys_alternatives }
    end

    add_index :surveys_alternatives_responses, [:response_id, :alternative_id], unique: true, name: "index_surveys_alternatives_responses"
  end
end
