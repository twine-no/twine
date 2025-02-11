module Surveys
  class Alternative < ApplicationRecord
    self.table_name = "surveys_alternatives"

    belongs_to :question, class_name: "Surveys::Question", required: true

    has_and_belongs_to_many :responses,
                            class_name: "Surveys::Response",
                            join_table: "surveys_alternatives_responses",
                            dependent: :destroy
  end
end
