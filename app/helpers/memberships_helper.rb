module MembershipsHelper
  def membership_role_color(membership)
    case membership.role
    when "member"
      "green"
    when "admin", "super_admin"
      "yellow"
    else
      raise "No color set for role: #{membership.role}"
    end
  end

  def membership_role_text(membership)
    case membership.role
    when "member"
      "Member"
    when "admin", "super_admin"
      "Admin"
    end
  end
end
