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
      if rsvp&.invite
        public_rsvps_path(meeting_guid: meeting.guid, invite_guid: rsvp.invite&.guid) # method: :post
      else
        new_public_rsvp_path(meeting_guid: meeting.guid, invite_guid: rsvp&.invite&.guid)
      end
    end
  end
end
