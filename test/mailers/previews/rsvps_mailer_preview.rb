class RsvpsMailerPreview < ActionMailer::Preview
  def confirmation
    RsvpsMailer.confirmation(Rsvp.last)
  end

  def updated_confirmation
    RsvpsMailer.updated_confirmation(Rsvp.last, [ "date", "location" ])
  end
end
