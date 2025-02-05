# Preview all emails at http://localhost:3000/rails/mailers/meeting_mailer
class MeetingMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/meeting_mailer/invite
  def invite
    InvitesMailer.invite(Invite.last.messages.last)
  end
end
