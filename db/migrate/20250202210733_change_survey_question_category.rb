class ChangeSurveyQuestionCategory < ActiveRecord::Migration[8.0]
  def change
    change_column_null :surveys_questions, :category, false
  end
end
