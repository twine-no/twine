require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  test "#validations should prevent changing role back to invited" do
    membership = memberships(:you_manage_the_coffee_shop)
    membership.role = :invited
    assert_not membership.save
    assert_equal [ "Can't be changed back to invited" ], membership.errors[:role]
  end

  test "#validations should not prevent update from member to admin" do
    membership = memberships(:you_manage_the_coffee_shop)
    membership.role = :admin
    assert membership.save
    assert_empty membership.errors
  end

  test "#table_filterable_scope allows you to filter by role" do
    memberships = Membership.table_filterable_scope("memberships.role": "member")
    assert memberships.all?(&:member?)
  end

  test "#table_filterable_scope allows you to filter by multiple roles" do
    memberships = Membership.table_filterable_scope("memberships.role": "admin,super_admin")
    assert memberships.all? { |membership| membership.admin? || membership.super_admin? }
  end

  test "#table_filterable_scope does not allow filtering by any parameters that haven't been explicitly allowed`" do
    memberships = Membership.table_filterable_scope("memberships.first_name": "name")
    assert_equal memberships.size, Membership.count
  end
end
