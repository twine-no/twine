module ShareableHelper
  def public_shareable_url(shareable)
    case shareable.class.name
    when "Group"
      public_group_url(shareable.guid)
    when "Meeting"
      public_event_url(shareable.guid)
    else
      raise "Unknown shareable: #{shareable.inspect}"
    end
  end

  def shareable_name(shareable)
    case shareable.class.name
    when "Group"
      "group"
    when "Meeting"
      "event"
    else
      raise "Unknown shareable: #{shareable.inspect}"
    end
  end
end
