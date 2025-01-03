module SurveysHelper
  def surveys_question_placeholder
    [
      "i.e. \"Which days work best for you?\"",
      "i.e. \"I'm ordering food — any allergies?\"",
      "i.e. \"Do you want to meet in-person or virtually?\"",
      "i.e. \"Any comments you want to share before the meeting?\""
    ].sample
  end
end
