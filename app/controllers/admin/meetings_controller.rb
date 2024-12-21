module Admin
  class MeetingsController < AdminController
    before_action :set_meeting, only: %i[show edit update destroy]

    def new
      @meeting = Meeting.new
      show_as_modal_inside :index
    end

    def create
      @meeting = Current.platform.meetings.new(meeting_params)
      if @meeting.save
        redirect_to admin_meeting_path(@meeting), notice: "Meeting created."
      else
        render :new, status: :unprocessable_content
      end
    end

    def index
      set_data_table_page Current.platform.meetings,
                          allow_sort_by: %w[meetings.title meetings.scheduled_at],
                          default_sort_by: "meetings.scheduled_at",
                          default_sort_direction: :asc
    end

    def show
    end

    def edit
    end

    def update
      if @meeting.update(meeting_params)
        redirect_to admin_meeting_path(@meeting), notice: "Meeting updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @meeting.destroy!
      redirect_to admin_meetings_path, notice: "Meeting destroyed"
    end

    private

    def set_meeting
      @meeting = Current.platform.meetings.find(params[:id])
    end

    def meeting_params
      params.require(:meeting).permit(:title, :scheduled_at)
    end
  end
end
