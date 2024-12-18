class Membership < ApplicationRecord
  include Tables::SupportsAdvancedQueries

  belongs_to :platform, required: true
  belongs_to :user, required: true

  enum :role, %i[member admin super_admin]

  table_filter_by %w[role]
  table_sort_by %w[users.email users.first_name users.last_name]

  scope :table_searchable_scope, ->(search_term) do
    joins(:user)
      .where(
        "users.first_name LIKE :search_term OR users.last_name LIKE :search_term OR users.email LIKE :search_term",
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
