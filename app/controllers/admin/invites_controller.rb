module Admin
  class InvitesController < AdminController
    before_action :set_meeting, only: [ :create, :destroy ]
    before_action :set_invite, only: [ :destroy ]

    def create
      @invite = @meeting.invites.new(invite_params)
      if @invite.save!
        redirect_to [ :admin, @meeting ]
      else
        render :index, status: :unprocessable_content
      end
    end

    def destroy
      if @invite.destroy!
        redirect_to [ :admin, @meeting ]
      else
        render :index, status: :unprocessable_content
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
