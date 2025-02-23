class InvitesMailer < ApplicationMailer
  include DatesHelper

  def details_updated(invite)
  end

  def send_message(message)
    @message = message
    @invite = message.messageable
    @platform = @invite.meeting.platform
    mail subject: "Invite to #{@invite.meeting.title} #{datetime_format @invite.meeting.happens_at, format: :datetime}",
         to: @invite.contact.email
  end
end
