class Rsvp < ApplicationRecord
  belongs_to :invite, required: true

  enum :answer, %i[unanswered yes no]
end
