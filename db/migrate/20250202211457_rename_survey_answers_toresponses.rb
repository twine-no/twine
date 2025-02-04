class RenameSurveyAnswersToresponses < ActiveRecord::Migration[8.0]
  def change
    rename_table :surveys_answers, :surveys_responses
  end
end
