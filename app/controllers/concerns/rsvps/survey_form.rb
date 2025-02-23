module Rsvps
  module SurveyForm
    include ActiveSupport::Concern

    def build_survey_form
      @survey = @rsvp.meeting.survey
      return unless @survey

      answered_question_ids = @rsvp.survey_responses.pluck(:question_id)
      @survey.questions.each do |question|
        next if question.id.in?(answered_question_ids)

        @rsvp.survey_responses.build(question: question)
      end
    end
  end
end
