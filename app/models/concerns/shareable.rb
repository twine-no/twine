module Shareable
  extend ActiveSupport::Concern
  include UsesGuid

  included do
    scope :open, -> { share_by_link.or(share_by_calendar) }
    scope :share_by_calendar, -> { where(share_by_calendar: true) }
    scope :share_by_link, -> { where(share_by_link: true) }
    scope :closed, -> { where(share_by_calendar: false, share_by_link: false) }
  end

  def open?
    share_by_link? || share_by_calendar?
  end
end
