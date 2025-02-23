module Admin
  class RsvpsController < AdminController
    before_action :set_meeting, only: [ :create, :update ]
    before_action :set_invite, only: [ :create ]
    before_action :set_rsvp, only: [ :update ]

    def create
      @rsvp = @meeting.rsvps.new(rsvp_params.merge(invite: @invite))
      if @rsvp.save
        redirect_to admin_meeting_path(@meeting), notice: "Updated #{@rsvp.invite.contact.full_name}"
      else
        redirect_to admin_meeting_path(@meeting), notice: "Unable to update #{@rsvp.contact.full_name}"
      end
    end

    def update
      if @rsvp.update(rsvp_params)
        redirect_to admin_meeting_path(@meeting), notice: "Updated #{@rsvp.invite.contact.full_name}"
      else
        redirect_to admin_meeting_invite_path(@invite, meeting_id: @meeting.id),
                    notice: "Unable to update #{@rsvp.contact.first_name}"
      end
    end

    private

    def set_meeting
      @meeting = Current.platform.meetings.find(params[:meeting_id])
    end

    def set_invite
      @invite = @meeting.invites.find_by!(guid: params[:invite_guid])
    end

    def set_rsvp
      @rsvp = @meeting.rsvps.find_by!(guid: params[:id])
    end

    def rsvp_params
      params.require(:rsvp).permit(
        :full_name,
        :email,
        :answer,
        survey_responses_attributes: [
          :id,
          :question_id,
          :answer,
          alternative_ids: []
        ]
      )
    end
  end
end
