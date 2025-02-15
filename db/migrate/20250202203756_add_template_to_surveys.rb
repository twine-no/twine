class AddTemplateToSurveys < ActiveRecord::Migration[8.0]
  def change
    add_column :surveys, :template, :string, default: "custom", null: false
  end
end
