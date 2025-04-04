module Admin
  class SharesController < AdminController
    before_action :set_shareable, only: [:show, :update]

    def show
      case @shareable.class.name
      when "Meeting"
        redirect_to admin_meeting_path(@shareable) unless turbo_frame_request?
      when "Group"
        redirect_to edit_admin_group_path(@shareable) unless turbo_frame_request?
      else
        raise "Unknown shareable class #{@shareable.class.name}"
      end
    end

    def update
      @shareable.update!(shareable_params)
      render :show
    end

    private

    def set_shareable
      case params[:shareable_type]
      when "Meeting"
        @shareable = Current.platform.meetings.find(params[:shareable_id])
      when "Group"
        @shareable = Current.platform.groups.find(params[:shareable_id])
      else
        not_found!
      end
    end

    def shareable_params
      params.require(:shareable).permit(:share_by_link, :share_by_calendar)
    end
  end
end
