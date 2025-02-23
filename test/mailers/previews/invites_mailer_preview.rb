class InvitesMailerPreview < ActionMailer::Preview
  def details_updated
    InvitesMailer.details_updated(Invite.last)
  end

  def send_message
    InvitesMailer.send_message(Invite.messaged.last.messages.last)
  end
end
