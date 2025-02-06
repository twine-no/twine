# Preview all emails at http://localhost:3000/rails/mailers/meeting_mailer
class MeetingMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/meeting_mailer/invite
  def send_message
    InvitesMailer.send_message(Invite.messaged.last.messages.last)
  end
end
