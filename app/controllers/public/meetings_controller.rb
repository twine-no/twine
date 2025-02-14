module Public
  class MeetingsController < PublicController
    before_action :set_meeting_and_invite, only: :show

    def show
    end

    private

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
