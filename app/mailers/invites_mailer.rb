class InvitesMailer < ApplicationMailer
  include DatesHelper

  def invite(message)
    @message = message
    @invite = message.messageable
    mail subject: "Invite to #{@invite.meeting.title} #{datetime_format @invite.meeting.happens_at, format: :datetime}",
         to: @invite.contact.email
  end
end
