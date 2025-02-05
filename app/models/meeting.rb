class Meeting < ApplicationRecord
  include Messageable
  include Tables::SupportsAdvancedQueries
  include UsesGuid

  belongs_to :platform, required: true
  validates :title, presence: true

  has_many :invites, dependent: :destroy
  has_many :rsvps, dependent: :destroy
  has_many :surveys, dependent: :destroy
  has_many :log_entries, class_name: "MeetingLogEntry", dependent: :destroy
  has_many :messages, through: :invites

  broadcasts_refreshes

  table_filter_by %w[happens_at]

  has_rich_text :description

  scope :table_searchable_scope, ->(search_term) do
    where(
      "LOWER(meetings.title) LIKE :search_term OR lower(meetings.location) LIKE :search_term OR lower(meetings.description) LIKE :search_term",
      search_term: "%#{search_term}%"
    )
  end

  scope :open, -> { where(open: true) }
  scope :closed, -> { where(open: false) }
  scope :past, -> { where(happens_at: ..Time.current) }
  scope :upcoming, -> { where(happens_at: Time.current...) }
  scope :unscheduled, -> { where(happens_at: nil) }
  scope :planned, -> { upcoming.or(unscheduled) }
  scope :next_up, -> { order(Meeting.arel_table[:happens_at].asc.nulls_last).first }

  def log!(category, by:)
    log_entries.create!(
      category: category,
      user: by,
      happened_at: Time.current
    )
  end

  def scheduled?
    happens_at?
  end

  def past?
    scheduled? && happens_at.past?
  end

  def upcoming?
    scheduled? && !happens_at.past?
  end

  def invitable_memberships(from: platform)
    from.memberships.where.not(id: invites.pluck(:membership_id))
  end
end
