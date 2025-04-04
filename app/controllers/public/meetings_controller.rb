module Public
  class MeetingsController < PublicController
    before_action :set_platform, only: :index
    before_action :set_meeting_and_invite, only: :show

    def index
      meetings = @platform.meetings.share_by_calendar.planned
      @meetings_by_date = meetings.group_by do |meeting|
        meeting.starts_at&.to_date
      end.sort_by do |date, _meetings|
        date.nil? ? [ 0, Date.new(0) ] : [ 1, date ]
      end
    end

    def show
    end

    private

    def set_platform
      @platform = Platform.find_by!(shortname: params[:shortname])
    end

    def set_meeting_and_invite
      if params[:invite_guid]
        @meeting = Meeting.find_by!(guid: params[:guid])
        @invite = @meeting.invites.find_by!(guid: params[:invite_guid])
      else
        @meeting = Meeting.open.find_by!(guid: params[:guid])
        invite_guid_cookie = cookies["#{@meeting.guid}_invite_guid"]
        return unless invite_guid_cookie.present?

        @invite = Invite.find_by(guid: invite_guid_cookie)
      end
    end
  end
end
