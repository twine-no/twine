module Public
  class RsvpsController < PublicController
    include Rsvps::SurveyForm

    before_action :set_meeting, only: [ :new, :create, :edit, :update ]
    before_action :set_invite, only: [ :new, :create ]
    before_action :set_rsvp, only: [ :edit, :update ]
    before_action :set_survey, only: [ :create, :update ]

    def new
      @rsvp = @invite&.rsvp || Rsvp.new(invite: @invite, meeting: @meeting)
      build_survey_form
    end

    def create
      @rsvp = @meeting.rsvps.new(
        rsvp_params.merge(
          {
            invite: @invite || @meeting.invites.new,
            meeting: @invite&.meeting || @meeting,
            email: @invite&.contact&.email
          }.compact
        )
      )

      if @invite || @meeting.open?
        existing_rsvp = @meeting.rsvps.find_by(email: @rsvp.email)
        if existing_rsvp
          redirect_to public_event_path({ guid: @meeting.guid, invite_guid: @invite&.guid }.compact),
                      notice: "Already signed up. Edit your response from the link in your confirmation email"
        elsif @rsvp.save
          if @rsvp.yes?
            send_confirmation_email
            notice = "You're in. We sent a confirmation to #{@rsvp.email}"
          else
            notice = "You declined"
          end

          cookies["#{@meeting.guid}_invite_guid"] = @rsvp.invite.guid
          redirect_to public_event_path({ guid: @meeting.guid, invite_guid: @invite&.guid }.compact), notice: notice
        else
          render :new, status: :unprocessable_content
        end
      else
        @rsvp.errors.add(:base, "No longer open to new entries")
        render :new, status: :unprocessable_content
      end
    end

    def edit
      build_survey_form
    end

    def update
      if @rsvp.update(rsvp_params)
        send_confirmation_email if @rsvp.yes?

        redirect_to public_event_path(
                      {
                        guid: @rsvp.meeting.guid,
                        invite_guid: @rsvp.invite&.guid
                      }.compact
                    ),
                    notice: "Updated answer"
      else
        render_inside_modal :edit, status: :unprocessable_content
      end
    end

    private

    def send_confirmation_email
      mailer = RsvpsMailer.confirmation(@rsvp)
      Rails.env.development? ? mailer.deliver_now : mailer.deliver_later
    end

    def set_meeting
      @meeting = Meeting.find_by!(guid: params[:meeting_guid])
    end

    def set_invite
      return unless params[:invite_guid].present?

      @invite = @meeting.invites.find_by!(guid: params[:invite_guid])
    end

    def set_rsvp
      @rsvp = @meeting.rsvps.find_by!(guid: params[:id])
    end

    def set_survey
      @survey = (@rsvp&.meeting || @meeting).survey
    end

    def rsvp_params
      params.require(:rsvp).permit(
        :full_name,
        :email,
        :answer,
        survey_responses_attributes: [ :id, :question_id, :answer, alternative_ids: [] ]
      )
    end
  end
end
