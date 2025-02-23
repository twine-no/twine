require "test_helper"

module Admin
  class RsvpsControllerTest < ActionDispatch::IntegrationTest
    test "#create lets an admin create an RSVP on behalf of a User" do
      invite = meetings(:next_coffee_shop_board_meeting).invites.create!(membership: memberships(:dave_is_a_coffee_shop_shareholder))

      login_as users(:admin), on: platforms(:coffee_shop)
      assert_difference -> { meetings(:next_coffee_shop_board_meeting).rsvps.count }, 1 do
        post admin_meeting_rsvps_url(meetings(:next_coffee_shop_board_meeting)), params: {
          invite_guid: invite.guid,
          meeting_id: meetings(:next_coffee_shop_board_meeting).id,
          rsvp: {
            answer: "yes"
          }
        }
        assert_redirected_to admin_meeting_path(meetings(:next_coffee_shop_board_meeting))
      end
    end

    test "#create is not found for admin for other platform" do
      invite = meetings(:next_coffee_shop_board_meeting).invites.create!(membership: memberships(:dave_is_a_coffee_shop_shareholder))

      login_as users(:dave), on: platforms(:coffee_shop)
      assert_no_difference -> { meetings(:next_coffee_shop_board_meeting).rsvps.count } do
        post admin_meeting_rsvps_url(meetings(:next_coffee_shop_board_meeting)), params: {
          invite_guid: invite.guid,
          meeting_id: meetings(:next_coffee_shop_board_meeting).id,
          rsvp: {
            answer: "yes"
          }
        }
        assert_response :not_found
      end
    end

    test "#create does not let admin modify the RSVP of another meeting" do
      invite = meetings(:previous_coffee_shop_board_meeting).invites.create!(membership: memberships(:dave_is_a_coffee_shop_shareholder))

      login_as users(:admin), on: platforms(:coffee_shop)
      assert_no_difference -> { meetings(:next_coffee_shop_board_meeting).rsvps.count } do
        post admin_meeting_rsvps_url(meetings(:next_coffee_shop_board_meeting)), params: {
          invite_guid: invite.guid,
          meeting_id: meetings(:next_coffee_shop_board_meeting).id,
          rsvp: {
            answer: "yes"
          }
        }
        assert_response :not_found
      end
    end

    test "#update lets you update a User's RVP" do
      invite = meetings(:next_coffee_shop_board_meeting).invites.create!(membership: memberships(:dave_is_a_coffee_shop_shareholder))
      rsvp = Rsvp.create!(invite: invite, meeting: meetings(:next_coffee_shop_board_meeting), answer: "yes")

      login_as users(:admin), on: platforms(:coffee_shop)
      assert_no_difference -> { meetings(:next_coffee_shop_board_meeting).rsvps.count } do
        patch admin_meeting_rsvp_url(rsvp, meeting_id: meetings(:next_coffee_shop_board_meeting).id), params: {
          meeting_id: meetings(:next_coffee_shop_board_meeting).id,
          rsvp: {
            answer: "no",
            email: "newemail@mail.com",
            full_name: "New Name"
          }
        }
        assert_redirected_to admin_meeting_path(meetings(:next_coffee_shop_board_meeting))
      end

      rsvp.reload

      assert_equal "no", rsvp.answer
      assert_equal "newemail@mail.com", rsvp.email
      assert_equal "New Name", rsvp.full_name
    end

    test "#update lets you update User's Survey response" do
      invite = meetings(:next_coffee_shop_board_meeting).invites.create!(membership: memberships(:dave_is_a_coffee_shop_shareholder))
      rsvp = Rsvp.create!(invite: invite, meeting: meetings(:next_coffee_shop_board_meeting), answer: "yes")
      survey = Survey.create!(template: :meeting_date, meeting: meetings(:next_coffee_shop_board_meeting))
      question = survey.questions.create!(title: "Do you have any allergies?", category: :free_text)
      response = question.responses.create!(rsvp: rsvp, answer: "")

      login_as users(:admin), on: platforms(:coffee_shop)
      assert_no_difference -> { meetings(:next_coffee_shop_board_meeting).rsvps.count } do
        patch admin_meeting_rsvp_url(rsvp, meeting_id: meetings(:next_coffee_shop_board_meeting).id), params: {
          meeting_id: meetings(:next_coffee_shop_board_meeting).id,
          rsvp: {
            survey_responses_attributes: {
              "0" => {
                id: response.id,
                answer: "Gluten"
              }
            }
          }
        }
        assert_redirected_to admin_meeting_path(meetings(:next_coffee_shop_board_meeting))
      end

      response.reload

      assert_equal "Gluten", response.answer
    end
  end
end
