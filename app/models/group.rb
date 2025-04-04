class Group < ApplicationRecord
  include Shareable

  belongs_to :platform, required: true
  has_and_belongs_to_many :memberships, counter_cache: true

  validates :name, presence: true, uniqueness: { scope: :platform_id }
end
