class Membership < ApplicationRecord
  belongs_to :platform, required: true
  belongs_to :user, required: true

  enum :role, %i[member admin]
end
