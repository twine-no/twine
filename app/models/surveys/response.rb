module Surveys
  class Response < ApplicationRecord
    self.table_name = "surveys_responses"

    belongs_to :answer, class_name: "Surveys::Answer", required: true
  end
end
