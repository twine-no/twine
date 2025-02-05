module MessagesHelper
  def messages_title(message)
    case message.messageable.class.name
    when "Meeting"
      "Write an invite"
    else
      raise "Unknown class: #{message.messageable.class}"
    end
  end

  def messages_default_content(message)
    case message.messageable.class.name
    when "Meeting"
      message.messageable.description
    else
      raise "Unknown class: #{message.messageable.class}"
    end
  end

  def messages_action_text(message)
    case message.messageable.class.name
    when "Meeting"
      "Invite #{pluralize(message.messageable.invites.not_messaged.size, "member")}"
    else
      raise "Unknown class: #{message.messageable.class}"
    end
  end
end
