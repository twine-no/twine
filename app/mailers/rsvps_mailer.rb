require "icalendar"

class RsvpsMailer < ApplicationMailer
  helper DatesHelper
  include DatesHelper

  after_deliver -> { @rsvp.confirmation_sent! }, only: [ :confirmation, :updated_confirmation ]

  def confirmation(rsvp)
    @rsvp = rsvp
    @platform = rsvp.meeting.platform
    date_string = " on #{datetime_format(rsvp.meeting.happens_at, format: :pretty_datetime)}" if rsvp.meeting.scheduled?

    attachments["invite.ics"] = generate_calendar_attachment(rsvp) if rsvp.meeting.scheduled?
    mail subject: "Confirmation: #{rsvp.meeting.title}#{date_string}",
         to: rsvp.invite.contact.email
  end

  def updated_confirmation(rsvp, updated_attributes)
    @rsvp = rsvp
    @platform = rsvp.meeting.platform
    @updated_attributes = updated_attributes
    date_string = " on #{datetime_format(rsvp.meeting.happens_at, format: :pretty_datetime)}" if rsvp.meeting.scheduled?

    attachments["invite.ics"] = generate_calendar_attachment(rsvp) if rsvp.meeting.scheduled?
    mail subject: "Updated event: #{rsvp.meeting.title}#{date_string}",
         to: rsvp.invite.contact.email
  end

  private

  def generate_calendar_attachment(rsvp)
    calendar = Icalendar::Calendar.new
    calendar.event do |event|
      event.dtstart = rsvp.meeting.happens_at.utc
      event.summary = rsvp.meeting.title
      event.location = rsvp.meeting.location
      event.description = rsvp.meeting.description.to_plain_text
      event.ip_class = "PRIVATE"
    end

    calendar.publish

    {
      mime_type: "text/calendar",
      content: calendar.to_ical
    }
  end
end
