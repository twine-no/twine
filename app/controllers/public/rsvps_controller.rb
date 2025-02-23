module Public
  class RsvpsController < PublicController
    before_action :set_meeting, only: [ :new, :create ]
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
        if @rsvp.save
          mailer = RsvpsMailer.confirmation(@rsvp)
          Rails.env.development? ? mailer.deliver_now : mailer.deliver_later
          cookies["#{@meeting.guid}_invite_guid"] = @rsvp.invite.guid
          notice = @rsvp.answer == "yes" ? "You're in. We sent a confirmation to #{@rsvp.email}" : "You declined"
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
      redirect_to public_event_path(@rsvp.invite.meeting.guid, invite_guid: @rsvp.invite.guid) unless turbo_frame_request?
      build_survey_form
    end

    def update
      if @rsvp.update(rsvp_params)
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

    def set_meeting
      @meeting = Meeting.find_by!(guid: params[:meeting_guid])
    end

    def set_invite
      return unless params[:invite_guid].present?

      @invite = @meeting.invites.find_by!(guid: params[:invite_guid])
    end

    def set_rsvp
      @rsvp = Rsvp.find_by!(guid: params[:id])
    end

    def set_survey
      @survey = (@rsvp&.meeting || @meeting).surveys.find_by(id: params[:survey_id])
    end

    def rsvp_params
      params.require(:rsvp).permit(
        :full_name,
        :email,
        :answer,
        survey_responses_attributes: [ :id, :question_id, :answer, alternative_ids: [] ]
      )
    end

    def build_survey_form
      @survey = @rsvp.meeting.surveys.last
      return unless @survey

      answered_question_ids = @rsvp.survey_responses.pluck(:question_id)
      @survey.questions.each do |question|
        next if question.id.in?(answered_question_ids)

        @rsvp.survey_responses.build(question: question)
      end
    end
  end
end
