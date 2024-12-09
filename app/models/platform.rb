class Platform < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  enum :category, %i[unorganised shareholder_org member_org]
end
