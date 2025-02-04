class Survey < ApplicationRecord
  include UsesGuid

  belongs_to :meeting
  has_many :questions, class_name: "Surveys::Question", dependent: :destroy
  accepts_nested_attributes_for :questions, allow_destroy: true

  has_many :responses, through: :questions

  scope :open, -> { where(open: true) }

  enum :template, { custom: "custom", meeting_date: "meeting_date" }
end
