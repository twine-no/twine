module RsvpsHelper
  def rsvps_action_text(rsvp, meeting)
    case rsvp&.answer
    when "yes"
      "✅ You accepted (change)"
    when "no"
      "❌ You declined (change)"
    else
      "✋ Let #{meeting.platform.name} know if you can make it"
    end
  end

  def rsvps_action_link(rsvp, meeting)
    case rsvp&.answer
    when "yes", "no"
      edit_public_rsvp_path(rsvp)
    else
      public_rsvps_path(
        meeting_guid: meeting.guid,
        invite_guid: rsvp.invite&.guid
      )
    end
  end

  def rsvp_status_badge(invite)
    id = "#{dom_id(invite)}_rsvp"
    case invite.rsvp_status
    when "yes"
      badge invite.self_signup? ? "Signed up" : "Accepted", color: :green, id: id
    when "no"
      badge "Declined", color: :red, id: id
    when "Not invited"
      badge "Invite not sent", color: :gray, id: id
    else
      badge invite.rsvp_status.humanize, color: :gray, id: id
    end
  end
end
