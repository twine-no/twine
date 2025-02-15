module Surveys
  class Question < ApplicationRecord
    self.table_name = "surveys_questions"

    belongs_to :survey
    has_many :alternatives, class_name: "Surveys::Alternative", dependent: :destroy
    has_many :responses, class_name: "Surveys::Response", dependent: :destroy
    accepts_nested_attributes_for :alternatives, allow_destroy: true

    enum :category, { "free_text": "free_text", multiple_choice: "multiple_choice" }

    validates :category, presence: true
  end
end
