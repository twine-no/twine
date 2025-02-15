module MeetingsHelper
  def invite_remaining_members_text(meeting)
    return "Everyone" if meeting.invites.none?

    "#{pluralize(meeting.invitable_memberships.size, "remaining member")}"
  end
end
