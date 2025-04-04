require "uri"

class Meeting < ApplicationRecord
  include Messageable
  include Tables::SupportsAdvancedQueries
  include Shareable

  belongs_to :platform, required: true
  validates :title, presence: true

  before_save :set_location_updated_timestamp, if: :location_changed?
  before_save :set_starts_at_updated_timestamp, if: :starts_at_changed?

  has_many :invites, dependent: :destroy
  has_many :rsvps, dependent: :destroy
  has_many :log_entries, class_name: "MeetingLogEntry", dependent: :destroy
  has_many :messages, through: :invites

  has_one :survey, dependent: :destroy

  has_rich_text :description

  has_one_attached :logo do |attachable|
    attachable.variant :thumbnail, resize_to_limit: [300, 300]
  end

  broadcasts_refreshes

  table_filter_by %w[starts_at]

  scope :table_searchable_scope, ->(search_term) do
    where(
      "LOWER(meetings.title) LIKE :search_term OR lower(meetings.location) LIKE :search_term OR lower(meetings.description) LIKE :search_term",
      search_term: "%#{search_term}%"
    )
  end

  scope :past, -> { where(starts_at: ..Time.current) }
  scope :upcoming, -> { where(starts_at: Time.current...) }
  scope :unscheduled, -> { where(starts_at: nil) }
  scope :next_up, -> { order(Meeting.arel_table[:starts_at].asc.nulls_last).first }
  scope :planned, -> { where(starts_at: Time.current.beginning_of_day..).or(unscheduled).order(Meeting.arel_table[:starts_at].asc.nulls_last) }
  scope :finished, -> { scheduled.where.not(starts_at: Time.current.beginning_of_day..) }

  def log!(category, by:)
    log_entries.create!(
      category: category,
      user: by,
      happened_at: Time.current
    )
  end

  def scheduled?
    starts_at?
  end

  def ongoing?
    starts_at.past? && ends_at&.future?
  end

  def past?
    scheduled? && (ends_at || starts_at).past?
  end

  def upcoming?
    scheduled? && starts_at.future?
  end

  def online?
    return false if location.blank?

    location =~ URI.regexp
  end

  def location_name
    return location unless online?

    uri_parsed_location = URI.parse(location)
    case uri_parsed_location.host
    when /meet.google.com/
      "Google Meet"
    when /teams.microsoft.com/
      "Microsoft Teams"
    when /whereby.com/
      "Whereby"
    when /zoom.us/
      "Zoom"
    else
      "#{uri_parsed_location.host}#{uri_parsed_location.path}"
    end
  end

  def invitable_memberships(from: platform)
    from.memberships.where.not(id: invites.pluck(:membership_id))
  end

  def everyone_informed_of_date?
    return true if starts_at_updated_at.nil?
    return true if rsvps.confirmation_sent.empty?

    starts_at_updated_at < last_confirmation_sent_at
  end

  def everyone_informed_of_location?
    return true if location_updated_at.nil?
    return true if rsvps.confirmation_sent.empty?

    location_updated_at < last_confirmation_sent_at
  end

  def last_confirmation_sent_at
    rsvps.confirmation_sent.maximum(:confirmation_sent_at)
  end

  def unconfirmed_rsvps
    rsvps
      .where(answer: :yes)
      .confirmation_sent.where(
      "confirmation_sent_at < ? OR confirmation_sent_at < ?",
      starts_at_updated_at,
      location_updated_at
    )
  end

  def recurring?
    false # TODO: Add
  end

  # For simple_calendar
  def start_time
    starts_at
  end

  # Potential bottleneck
  def update_rsvp_counters!
    update!(
      rsvps_count: rsvps.yes.count,
      rsvps_yes_count: rsvps.yes.count,
      rsvps_no_count: rsvps.no.count
    )
  end

  private

  def set_location_updated_timestamp
    self.location_updated_at = Time.current
  end

  def set_starts_at_updated_timestamp
    self.starts_at_updated_at = Time.current
  end
end
