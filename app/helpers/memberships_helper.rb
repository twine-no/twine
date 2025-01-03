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

  def selectable_membership_roles_for(membership)
    Membership.roles.except("invited").map do |key, _value|
      [key.humanize, key, selected: membership.role == key]
    end
  end

  def membership_disabled_reason(membership)
    return "Can't edit role of user who hasn't signed up yet" if membership.invited?

    if membership.user == Current.user
      if membership.super_admin?
        "You can't edit your own role. If you don't want to be super admin, give the role to someone else, and ask them demote to you."
      else
        "You can't edit your own role"
      end
    else
      raise "No reason provided"
    end
  end
end
