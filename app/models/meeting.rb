class Meeting < ApplicationRecord
  include Tables::SupportsAdvancedQueries

  belongs_to :platform, optional: false

  validates :title, presence: true
  validates :scheduled_at, presence: true

  table_filter_by %w[scheduled_at]

  scope :table_searchable_scope, ->(search_term) do
    where(
      "LOWER(meetings.title) LIKE :search_term",
      search_term: "%#{search_term}%"
    )
  end

  scope :by_table_tab, ->(tab) do
    case tab
    when "past"
      past
    else
      upcoming
    end
  end

  scope :past, -> { where(scheduled_at: ..Time.current) }
  scope :upcoming, -> { where(scheduled_at: Time.current...) }

  def past?
    scheduled_at.past?
  end

  def upcoming?
    !past?
  end
end
