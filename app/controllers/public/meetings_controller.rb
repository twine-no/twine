module Public
  class MeetingsController < PublicController
    before_action :set_meeting, only: :show
    before_action :set_invite, only: :show

    def show
      @rsvp = if cookies["#{@meeting.guid}_rsvp_guid"]
                @meeting.rsvps.find_by(guid: cookies["#{@meeting.guid}_rsvp_guid"])
      else
                @invite&.rsvp || Rsvp.new
      end
    end

    private

    def set_meeting
      @meeting = Meeting.open.find_by!(guid: params[:id])
    end

    def set_invite
      @invite = @meeting.invites.find_by(guid: params[:invite_guid])
    end
  end
end
