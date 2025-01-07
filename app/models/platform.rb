class Platform < ApplicationRecord
  has_many :users, through: :memberships
  has_many :sessions, dependent: :delete_all
  has_many :groups, dependent: :delete_all
  has_many :memberships, dependent: :destroy
  has_many :meetings, dependent: :delete_all

  enum :category, %i[unorganised shareholder_org member_org]
end
