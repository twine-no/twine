class RemoveAlternativeFromResponses < ActiveRecord::Migration[8.0]
  def change
    remove_reference :surveys_responses, :alternative, null: false, index: true
  end
end
