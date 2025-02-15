module SurveysHelper
  def surveys_title(meeting)
    meeting_link = link_to(meeting.title, admin_meeting_path(meeting), class: "link link-primary")
    case @survey.template
    when "meeting_date"
      "Ask #{meeting_link} guests when they're available".html_safe
    else
      "Ask #{meeting_link} guests a question".html_safe
    end
  end

  def surveys_subtitle(_meeting)
    case @survey.template
    when "meeting_date"
      "The question will appear on their invite."
    else
      "The question will be asked when you send out the invite."
    end
  end

  def surveys_default_category
    case @survey.template
    when "meeting_date"
      "multiple_choice"
    else
      nil
    end
  end

  def surveys_question_placeholder
    return "When are you available?" if @survey.meeting_date?

    [
      "i.e. \"Which days work best for you?\"",
      "i.e. \"I'm ordering food — any allergies?\"",
      "i.e. \"Do you want to meet in-person or virtually?\"",
      "i.e. \"Any comments you want to share before the meeting?\""
    ].sample
  end

  def surveys_alternative_placeholder
    case @survey.template
    when "meeting_date"
      "Suggest a date/time"
    else
      "Add an option"
    end
  end
end
