class Meeting < ApplicationRecord
  include Tables::SupportsAdvancedQueries

  belongs_to :platform, required: true
  validates :title, presence: true

  has_many :invites, dependent: :destroy
  has_many :surveys, dependent: :destroy
  has_many :log_entries, class_name: "MeetingLogEntry", dependent: :destroy

  broadcasts_refreshes

  table_filter_by %w[scheduled_at]

  scope :table_searchable_scope, ->(search_term) do
    where(
      "LOWER(meetings.title) LIKE :search_term OR lower(meetings.location) LIKE :search_term OR lower(meetings.description) LIKE :search_term",
      search_term: "%#{search_term}%"
    )
  end

  scope :by_table_tab, ->(tab) do
    case tab
    when "past"
      past.order(scheduled_at: :desc)
    else
      upcoming.or(unscheduled).order(Meeting.arel_table[:scheduled_at].asc.nulls_first)
    end
  end

  scope :past, -> { where(scheduled_at: ..Time.current) }
  scope :upcoming, -> { where(scheduled_at: Time.current...) }
  scope :unscheduled, -> { where(scheduled_at: nil) }

  def log!(category, by:)
    log_entries.create!(
      category: category,
      user: by,
      happened_at: Time.current
    )
  end

  def scheduled?
    scheduled_at?
  end

  def past?
    scheduled? && scheduled_at.past?
  end

  def upcoming?
    scheduled? && !scheduled_at.past?
  end

  def invitable_memberships(from: platform)
    from.memberships.where.not(id: invites.pluck(:membership_id))
  end
end
