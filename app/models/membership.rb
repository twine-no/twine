class Membership < ApplicationRecord
  include Tables::SupportsAdvancedQueries

  belongs_to :platform, required: true
  belongs_to :user, required: true

  enum :role, %i[member admin super_admin invited]

  table_filter_by %w[role]

  validates :user_id, uniqueness: { scope: :platform_id, message: ->(membership, _data) do
    "#{membership.user.first_name} has already been invited at #{membership.user.email}"
  end
  }

  accepts_nested_attributes_for :user

  scope :table_searchable_scope, ->(search_term) do
    joins(:user)
      .where(
        "users.first_name || ' ' || users.last_name LIKE :search_term OR users.email LIKE :search_term",
        search_term: "%#{search_term}%"
      )
  end

  def grants_admin_rights?
    admin? || super_admin?
  end

  def grants_member_rights?
    member? || admin? || super_admin?
  end
end
