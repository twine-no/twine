module RsvpsHelper
  def rsvps_action_text(rsvp)
    case rsvp&.answer
    when "yes"
      "✅ You accepted (change)"
    when "no"
      "❌ You declined (change)"
    else
      "✋ Sign up"
    end
  end

  def rsvps_action_link(rsvp, meeting)
    case rsvp&.answer
    when "yes", "no"
      edit_public_rsvp_path(rsvp, meeting_guid: rsvp.meeting.guid)
    else
      public_rsvps_path(
        meeting_guid: meeting.guid,
        invite_guid: rsvp.invite&.guid
      )
    end
  end

  def rsvp_status_text(invite)
    case invite.rsvp_status
    when "yes"
      color_class = "text-secondary"
      rsvp_status = "Joined"
      timestamp = invite.rsvp.created_at
    when "no"
      color_class = "text-primary"
      rsvp_status = "Declined"
      timestamp = invite.rsvp.created_at
    when "invited", "unanswered"
      color_class = ""
      rsvp_status = "Invited"
      timestamp = invite.created_at
    else
      raise "Unknown rsvp_status: #{invite.rsvp_status}"
    end

    "<span class=\"#{color_class} font-semibold\">#{rsvp_status}</span><br><span class=\"text-gray-400 text-xs\">#{time_ago_in_words(timestamp).gsub("about", "")} ago</span>".html_safe
  end
end
