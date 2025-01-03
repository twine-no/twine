module Surveys
  class Question < ApplicationRecord
    self.table_name = "surveys_questions"

    belongs_to :survey
    has_many :alternatives, class_name: "Surveys::Alternative", dependent: :destroy
    accepts_nested_attributes_for :alternatives, allow_destroy: true

    enum :category, %w[free_text multiple_choice]
  end
end
