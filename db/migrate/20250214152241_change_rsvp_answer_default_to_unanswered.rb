class ChangeRsvpAnswerDefaultToUnanswered < ActiveRecord::Migration[8.0]
  def change
    change_column_default :rsvps, :answer, "unanswered"
  end
end
