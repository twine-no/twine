module Admin
  class SharesController < AdminController
    before_action :set_meeting, only: [:show, :update]

    def show
      redirect_to admin_meeting_path(@meeting) unless turbo_frame_request?
    end

    def update
      @meeting.update!(meeting_params)
      render :show
    end

    private

    def set_meeting
      @meeting = Current.platform.meetings.find(params[:meeting_id])
    end

    def meeting_params
      params.require(:meeting).permit(:open)
    end
  end
end
