require "uri"

class Meeting < ApplicationRecord
  include Messageable
  include Tables::SupportsAdvancedQueries
  include UsesGuid

  belongs_to :platform, required: true
  validates :title, presence: true

  before_save :set_location_updated_timestamp, if: :location_changed?
  before_save :set_happens_at_updated_timestamp, if: :happens_at_changed?

  has_many :invites, dependent: :destroy
  has_many :rsvps, dependent: :destroy
  has_many :log_entries, class_name: "MeetingLogEntry", dependent: :destroy
  has_many :messages, through: :invites

  has_one :survey, dependent: :destroy

  has_rich_text :description

  has_one_attached :logo do |attachable|
    attachable.variant :thumbnail, resize_to_limit: [ 300, 300 ]
  end

  broadcasts_refreshes

  table_filter_by %w[happens_at]

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
    return true if happens_at_updated_at.nil?
    return true if rsvps.confirmation_sent.empty?

    happens_at_updated_at < last_confirmation_sent_at
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
      happens_at_updated_at,
      location_updated_at
    )
  end

  private

  def set_location_updated_timestamp
    self.location_updated_at = Time.current
  end

  def set_happens_at_updated_timestamp
    self.happens_at_updated_at = Time.current
  end
end
