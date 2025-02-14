module Admin
  class InvitesController < AdminController
    before_action :set_meeting, only: [ :create, :show, :update, :destroy ]
    before_action :set_invite, only: [ :show, :update, :destroy ]

    def create
      @invite = @meeting.invites.new(invite_params)
      if @invite.save!
        redirect_to admin_meeting_path(@meeting)
      else
        redirect_to admin_meeting_path(@meeting), notice: "Unable to invite #{@invite.user.full_name}"
      end
    end

    def show
      redirect_to admin_meeting_path(@meeting) unless turbo_frame_request?
      @rsvp = @invite.rsvp || Rsvp.new(invite: @invite)
    end

    def update
      @rsvp = @invite.rsvp || Rsvp.new(invite: @invite)
      if @rsvp.update(
        answer: params[:rsvp_answer],
        meeting: @meeting
      )
      else
        redirect_to admin_meeting_invite_path(@invite, meeting_id: @meeting.id), notice: "Unable to remove #{@invite.user.full_name}"
      end
    end

    def destroy
      if @invite.destroy!
        redirect_to admin_meeting_path(@meeting)
      else
        redirect_to admin_meeting_path(@meeting), notice: "Unable to remove #{@invite.user.full_name}"
      end
    end

    private

    def set_meeting
      @meeting = Current.platform.meetings.find(params[:meeting_id])
    end

    def set_invite
      @invite = @meeting.invites.find(params[:id])
    end

    def invite_params
      params.require(:invite).permit(:membership_id)
    end
  end
end
