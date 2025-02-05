module Public
  class RsvpsController < PublicController
    before_action :set_meeting, only: [ :new, :create ]
    before_action :set_invite, only: [ :new, :create ]
    before_action :set_rsvp, only: [ :edit, :update ]

    def new
      @rsvp = @invite&.rsvp || Rsvp.new
    end

    def create
      @rsvp = @meeting.rsvps.new(
        rsvp_params.merge(
          {
            invite: @invite || @meeting.invites.new,
            email: @invite&.email
          }.compact
        )
      )

      if @invite || @meeting.open?
        if @rsvp.save
          cookies["#{@meeting.guid}_rsvp_guid"] = @rsvp.guid
          notice = @rsvp.answer == "yes" ? "You're in. You've received a confirmation on #{@rsvp.email}" : "You declined"
          redirect_to public_event_path({ id: @meeting.guid, invite_guid: @invite&.guid }.compact), notice: notice
        else
          render_inside_modal :new, status: :unprocessable_content
        end
      else
        @rsvp.errors.add(:base, "No longer open to new entries")
        render_inside_modal :new, status: :unprocessable_content
      end
    end

    def edit
    end

    def update
      if @rsvp.update(rsvp_params)
        redirect_to public_event_path({ id: @rsvp.meeting.guid, invite_guid: @rsvp.invite&.guid }.compact),
                    notice: "Updated answer"
      else
        render_inside_modal :edit, status: :unprocessable_content
      end
    end

    private

    def set_meeting
      @meeting = Meeting.find_by!(guid: params[:meeting_guid])
    end

    def set_invite
      return unless params[:invite_guid].present?

      @invite = @meeting.invites.find_by!(params[:invite_guid])
    end

    def set_rsvp
      @rsvp = Rsvp.find_by!(guid: params[:id])
    end

    def rsvp_params
      params.require(:rsvp).permit(:full_name, :email, :answer)
    end
  end
end
