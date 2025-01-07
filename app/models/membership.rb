class Membership < ApplicationRecord
  include Tables::SupportsAdvancedQueries

  belongs_to :platform, required: true
  belongs_to :user, required: true

  has_and_belongs_to_many :groups

  enum :role, %i[member admin super_admin invited]

  validate :role_was_not_set_back_to_invited, if: :role_changed?

  table_filter_by %w[role]

  validates :user_id, uniqueness: { scope: :platform_id, message: ->(membership, _data) do
    "#{membership.user.full_name} was already invited using #{membership.user.email}"
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

  def grants_super_admin_rights?
    super_admin?
  end

  def grants_admin_rights?
    admin? || super_admin?
  end

  def grants_member_rights?
    member? || admin? || super_admin?
  end

  private

  def role_was_not_set_back_to_invited
    self.errors.add(:role, "Can't be changed back to invited") if invited? && role_was != "invited"
  end
end
