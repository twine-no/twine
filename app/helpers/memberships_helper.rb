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
    role_text = case membership.role
    when "member"
                  "Member"
    when "admin", "super_admin"
                  "Admin"
    end

    if membership.user_id == Current.user.id
      icon = svg_tag("icons/mingcute/user_1_fill", class: "inline-block h-3 w-4")
      "#{role_text}#{icon}".html_safe
    else
      role_text
    end
  end
end
