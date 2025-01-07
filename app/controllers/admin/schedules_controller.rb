module Admin
  class SchedulesController < AdminController
    before_action :set_meeting, only: [:new, :create]

    def new
      render as_modal_inside "admin/meetings/show" do

      end
    end

    def create
      if @meeting.update(schedule_params)
        redirect_to [:admin, @meeting]
      else
        render_as_modal_inside "admin/meetings/show", status: :unprocessable_content
      end
    end

    private

    def set_meeting
      @meeting = Current.platform.meetings.find(params[:meeting_id])
    end

    def schedule_params
      params.require(:meeting).permit(:scheduled_at)
    end
  end
end
