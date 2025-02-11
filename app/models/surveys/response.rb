module Surveys
  class Response < ApplicationRecord
    self.table_name = "surveys_responses"

    belongs_to :question, required: true
    belongs_to :rsvp, required: true

    has_and_belongs_to_many :alternatives,
                            class_name: "Surveys::Alternative",
                            join_table: "surveys_alternatives_responses",
                            dependent: :destroy
  end
end
