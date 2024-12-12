class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :memberships
  has_many :platforms, through: :memberships

  normalizes :email, with: ->(e) { e.strip.downcase }

  def default_platform
    platforms.first
  end
end
