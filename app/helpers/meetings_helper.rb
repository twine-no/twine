module MeetingsHelper
  def invite_remaining_members_text(meeting)
    return "Add everyone" if meeting.invites.none?

    "Add #{pluralize(meeting.invitable_memberships.size, "remaining member")}"
  end
end
