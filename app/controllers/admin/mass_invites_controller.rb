module Admin
  class MassInvitesController < AdminController
    before_action :set_meeting, only: [:create]

    # Expand to support Membership groups or sub-platforms when that's introduced
    def create
      Meetings::MassInviteJob.perform_now(@meeting, invite_group: Current.platform)
      redirect_to [:admin, @meeting]
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
