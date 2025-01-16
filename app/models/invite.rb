class Invite < ApplicationRecord
  include Messageable
  include UsesGuid

  belongs_to :meeting, required: true, touch: true
  belongs_to :membership, required: true

  has_one :rsvp, dependent: :destroy

  scope :unanswered, -> { where.missing(:rsvp) }
  scope :answered_yes, -> { where.associated(:rsvp).where(rsvps: { answer: :yes }) }
  scope :answered_no, -> { where.associated(:rsvp).where(rsvps: { answer: :no }) }

  validates :membership_id, uniqueness: { scope: :meeting_id }
  validate :ensure_member_belongs_to_platform

  private

  def ensure_member_belongs_to_platform
    return if meeting.nil? || membership.nil?

    self.errors.add(:membership_id, "Member does not belong to platform") unless meeting.platform_id == membership.platform_id
  end
end
