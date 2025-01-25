module Admin
  class MeetingPreviewsController < AdminController
    before_action :set_meeting, only: %i[index]

    layout "logged_out"

    def index
      render "public/meetings/show"
    end

    private

    def set_meeting
      @meeting = Current.platform.meetings.find(params[:meeting_id])
    end
  end
end
