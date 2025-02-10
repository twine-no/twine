module Public
  class MeetingsController < PublicController
    before_action :set_meeting_and_invite, only: :show

    def show
      @rsvp = if !@invite && cookies["#{@meeting.guid}_rsvp_guid"]
                @meeting.rsvps.find_by(guid: cookies["#{@meeting.guid}_rsvp_guid"])
              else
                @invite&.rsvp || Rsvp.new(invite: @invite)
              end
    end

    private

    def set_meeting_and_invite
      if params[:invite_guid]
        @meeting = Meeting.find_by!(guid: params[:id])
        @invite = @meeting.invites.find_by!(guid: params[:invite_guid])
      else
        @meeting = Meeting.open.find_by!(guid: params[:id])
      end
    end
  end
end
