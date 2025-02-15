class AddRsvpToResponses < ActiveRecord::Migration[8.0]
  def change
    add_reference :surveys_responses, :rsvp, null: false, index: true
  end
end
