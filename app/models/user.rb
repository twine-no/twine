class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :memberships
  has_many :platforms, through: :memberships

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email" }

  has_secure_password :password, validations: false

  validates :password, length: { minimum: 8, maximum: 72 }, if: -> { password.present? }
  validates_confirmation_of :password, allow_blank: true
  validates :password_digest, presence: true, on: :create

  scope :registered, -> { where.not(registered_at: nil) }

  def default_platform
    platforms.first
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def has_super_admin_rights_at?(platform)
    memberships.find_by(platform: platform).grants_super_admin_rights?
  end

  def has_admin_rights_at?(platform)
    memberships.find_by(platform: platform).grants_admin_rights?
  end

  def has_member_rights_at?(platform)
    memberships.find_by(platform: platform).grants_member_rights?
  end

  def registered?
    registered_at?
  end
end
