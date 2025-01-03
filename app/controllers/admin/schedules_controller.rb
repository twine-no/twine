module Admin
  class SchedulesController < AdminController
    before_action :set_meeting, only: [:new, :create]

    def new
      show_as_modal_inside :show,
                           controller: MeetingsController.new,
                           modal_content_view: :new,
                           encapsulating_view: "admin/meetings/show",
                           extra_params: { id: @meeting.id }
    end

    def create
      if @meeting.update(schedule_params)
        redirect_to [:admin, @meeting]
      else
        show_as_modal_inside :show,
                             controller: MeetingsController.new,
                             modal_content_view: :new,
                             encapsulating_view: "admin/meetings/show",
                             extra_params: { id: @meeting.id }
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
