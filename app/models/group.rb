class Group < ApplicationRecord
  belongs_to :platform, required: true
  has_and_belongs_to_many :memberships

  validates :name, presence: true, uniqueness: { scope: :platform_id }
end
