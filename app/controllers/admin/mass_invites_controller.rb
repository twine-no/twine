module Admin
  class MassInvitesController < AdminController
    before_action :set_meeting, only: [:create]

    # Expand to support Membership groups or sub-platforms when that's introduced
    def create
      group = Current.platform.groups.find(params[:group_id]) if params[:group_id]
      invite_group = group || Current.platform
      Meetings::MassInviteJob.perform_later(@meeting, invite_groups: [invite_group])
      redirect_to admin_meeting_path(@meeting), notice: "Invited member".pluralize(@meeting.invitable_memberships(from: invite_group))
    end

    private

    def set_meeting
      @meeting = Current.platform.meetings.find(params[:meeting_id])
    end

    def invite_params
      params.require(:invite).permit(:membership_id)
    end
  end
end
