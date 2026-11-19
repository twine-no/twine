class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_one :page, dependent: :destroy

  accepts_nested_attributes_for :page

  has_secure_password

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email" }
  validates :password, length: { minimum: 8 }, allow_nil: true
end
