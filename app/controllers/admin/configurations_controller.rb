module Admin
  class ConfigurationsController < AdminController
    before_action :set_meeting, only: [ :show, :update ]

    def show
    end

    def update
      @meeting.update!(meeting_params)
      render :show
    end

    private

    def set_meeting
      @meeting = Meeting.find(params[:meeting_id])
    end

    def meeting_params
      params.require(:meeting).permit(:attendee_limit, :attendee_target)
    end
  end
end
