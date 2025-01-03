class MeetingLogEntry < ApplicationRecord
  belongs_to :meeting, required: true
  belongs_to :user, required: false

  enum :category, { created: "created" }

  validates :category, presence: true
  validates :happened_at, presence: true

  def description
    case category
    when "created"
      "Planning started by #{user.first_name}"
    when "updated"

    else
      raise "Unknown category: #{category}"
    end
  end
end
