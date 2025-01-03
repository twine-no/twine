module Surveys
  class Alternative < ApplicationRecord
    self.table_name = "surveys_alternatives"

    belongs_to :question, class_name: 'Surveys::Question'
  end
end
