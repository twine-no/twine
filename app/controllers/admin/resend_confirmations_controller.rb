module Admin
  class ResendConfirmationsController < AdminController
    before_action :set_meeting, only: [ :create ]

    def create
      unconfirmed_rsvps = @meeting.unconfirmed_rsvps.to_a
      @meeting.unconfirmed_rsvps.update!(confirmation_sent_at: nil)
      unconfirmed_rsvps.each do |rsvp|
        updated_attributes = []
        updated_attributes << "date" if rsvp.meeting.starts_at_updated_at && rsvp.meeting.starts_at_updated_at > rsvp.confirmation_sent_at
        updated_attributes << "location" if rsvp.meeting.location_updated_at && rsvp.meeting.location_updated_at > rsvp.confirmation_sent_at
        mail = RsvpsMailer.updated_confirmation(rsvp, updated_attributes)
        Rails.env.development? ? mail.deliver_now : mail.deliver_later
      end
      redirect_to admin_meeting_path(@meeting), notice: "Confirmation emails sent"
    end

    private

    def set_meeting
      @meeting = Current.platform.meetings.find(params[:meeting_id])
    end
  end
end
