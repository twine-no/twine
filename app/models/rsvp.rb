class Rsvp < ApplicationRecord
  include UsesGuid

  belongs_to :invite, required: false
  belongs_to :meeting, required: true

  enum :answer, { unanswered: "unanswered", yes: "yes", no: "no" }

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email" }
  validates :full_name, presence: true

  def to_param
    guid
  end
end
