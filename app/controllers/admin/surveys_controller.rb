module Admin
  class SurveysController < AdminController
    before_action :set_meeting, only: [ :new, :create, :edit, :update ]
    before_action :set_survey, only: [ :edit, :update ]

    def new
      @survey = build_survey_from_template
    end

    def create
      @survey = Survey.new(survey_params.merge(meeting: @meeting))
      @survey.open = true

      if @survey.save
        @survey.meeting.update!(happens_at: nil) if @survey.meeting_date?
        redirect_to admin_meeting_path(@survey.meeting), notice: generate_notice_based_on_survey_template
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit
    end

    def update
      if @survey.update(survey_params)
        @survey.meeting.update!(happens_at: nil) if @survey.meeting_date?
        redirect_to admin_meeting_path(@survey.meeting), notice: generate_notice_based_on_survey_template
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def set_meeting
      @meeting = Current.platform.meetings.find(params[:meeting_id])
    end

    def set_survey
      @survey = @meeting.survey # right now, we only have one survey per meeting
    end

    def survey_params
      params.require(:survey).permit(
        :template,
        questions_attributes: [
          :id, :title, :category, :_destroy,
          alternatives_attributes: [ :id, :title, :_destroy ]
        ]
      )
    end

    def build_survey_from_template
      survey = Survey.new(meeting: @meeting, template: params[:template])

      case survey.template
      when "meeting_date"
        question = survey.questions.build(title: "When are you available?", category: :multiple_choice)
        question.alternatives.build
        question.alternatives.build
      else
        # make an empty question
        survey.questions.build(category: :free_text)
      end

      survey
    end

    def generate_notice_based_on_survey_template
      case @survey.template
      when "meeting_date"
        "Will ask guests for suggestions."
      else
        "Question saved."
      end
    end
  end
end
