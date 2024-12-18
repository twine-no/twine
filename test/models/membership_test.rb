require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  test "#table_filterable_scope allows filtering by one or multiple roles" do
    assert Membership.table_filterable_scope('memberships.role': "super_admin").all?(&:super_admin?)
    assert Membership.table_filterable_scope('memberships.role': "admin,member").all? { |membership| membership.admin? || membership.member? }
  end

  test "#table_filterable_scope ignores filters that aren't explicitly allowed in Membership.table_filter_by" do
    assert_equal Membership.count, Membership.table_filterable_scope('users.role': "member").count
    assert_equal Membership.count, Membership.table_filterable_scope('memberships.id': "2").count
  end

  test "#table_filterable_scope will filter for enum values that don't exist" do
    assert_equal 0, Membership.table_filterable_scope('memberships.role': "foodie,car_salesman").count
  end
end
