class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :memberships
  has_many :platforms, through: :memberships

  normalizes :email, with: ->(e) { e.strip.downcase }

  def default_platform
    platforms.first
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def has_admin_rights_at?(platform)
    memberships.find_by(platform: platform).grants_admin_rights?
  end

  def has_member_rights_at?(platform)
    memberships.find_by(platform: platform).grants_member_rights?
  end
end
