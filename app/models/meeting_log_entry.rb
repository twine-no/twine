class MeetingLogEntry < ApplicationRecord
  belongs_to :meeting, required: true
  belongs_to :user, required: false

  enum :category, { created: "created" }

  validates :category, presence: true
  validates :happened_at, presence: true

  def description
    case category
    when "created"
      "#{user.first_name} started planning the meeting"
    when "updated"

    else
      raise "Unknown category: #{category}"
    end
  end
end
