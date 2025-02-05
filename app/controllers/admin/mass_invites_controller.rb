module Admin
  class MassInvitesController < AdminController
    before_action :set_meeting, only: [ :create ]

    # Expand to support Membership groups or sub-platforms when that's introduced
    def create
      @group = Current.platform.groups.find(params[:group_id]) if params[:group_id]
      Meetings::MassInviteJob.perform_now(@meeting, invite_groups: [ @group || Current.platform ])
      redirect_to admin_meeting_path(@meeting), notice: "Invited"
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
