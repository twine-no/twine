module Admin
  class SurveysController < AdminController
    before_action :set_meeting, only: [ :new, :create, :index ]
    before_action :set_survey, only: [ :show ]

    def new
      @survey = @meeting.surveys.build
      @survey.questions.build
    end

    def create
      @survey = @meeting.surveys.build(survey_params)
      @survey.open = true

      if @survey.save
        redirect_to admin_meeting_survey_path(@survey, meeting_id: @meeting.id), notice: "Survey created!"
      else
        render :new, status: :unprocessable_content
      end
    end

    def index
      @surveys = @meeting.surveys
      render_as_modal_inside "admin/meetings/show"
    end

    def show
    end

    private

    def set_meeting
      @meeting = Current.platform.meetings.find(params[:meeting_id])
    end

    def set_survey
      @meeting = @meeting.surveys.find(params[:id])
    end

    def survey_params
      params.require(:survey).permit(
        questions_attributes: [
          :id, :title, :category, :_destroy,
          alternatives_attributes: [ :id, :_destroy ]
        ]
      )
    end
  end
end
