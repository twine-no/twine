require "test_helper"

module Admin
  class MeetingsControllerTest < ActionDispatch::IntegrationTest
    test "#index succeeds for admin" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get admin_meetings_path
      assert_response :success
    end

    test "#index returns 404 for member" do
      login_as users(:member), on: platforms(:coffee_shop)
      get admin_meetings_path
      assert_response :not_found
    end

    test "#index redirects to login page if you're not logged in" do
      get admin_meetings_path
      assert_redirected_to new_session_path
    end

    test "#new succeeds" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get new_admin_meeting_path, headers: { "Turbo-Frame": :modal_content }
      assert_response :success
      assert_select "form#new_meeting"
    end

    test "#new redirects back to index unless turbo frame request" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get new_admin_meeting_path
      assert_redirected_to admin_meetings_path
    end

    test "#create succeeds, creates a new meeting, and redirects with a notice" do
      login_as users(:admin), on: platforms(:coffee_shop)
      meeting_name = "New Meeting"
      assert_difference -> { Meeting.count }, 1 do
        post admin_meetings_path, params: {
          meeting: {
            title: meeting_name,
            scheduled_at: 1.hour.from_now
          }
        }
      end
      assert_redirected_to admin_meeting_path(Meeting.last)
      assert_equal "#{meeting_name} saved", flash[:notice]
    end

    test "#create logs meeting creation" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_difference -> { MeetingLogEntry.count }, 1 do
        post admin_meetings_path, params: {
          meeting: {
            title: "New Meeting",
            scheduled_at: 1.hour.from_now
          }
        }
      end

      assert_equal 1, Meeting.last.log_entries.where(category: :created, happened_at: 5.seconds.ago..Time.current).size
    end

    test "#create renders errors when invalid data is provided" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_no_difference -> { Meeting.count } do
        post admin_meetings_path, params: {
          meeting: {
            title: "",
          }
        }
      end
      assert_response :unprocessable_content
      assert_select "form#new_meeting"
      assert_select ".form-error", text: /Title can't be blank/
    end

    test "#show succeeds" do
      login_as users(:admin), on: platforms(:coffee_shop)
      meeting = meetings(:next_coffee_shop_board_meeting)

      get admin_meeting_path(meeting)
      assert_response :success
    end

    test "#show returns 404 if meeting belongs to a different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      meeting = meetings(:football_club_training)

      get admin_meeting_path(meeting)
      assert_response :not_found
    end

    test "#edit succeeds for admin" do
      login_as users(:admin), on: platforms(:coffee_shop)
      meeting = meetings(:next_coffee_shop_board_meeting)

      get edit_admin_meeting_path(meeting)
      assert_response :success
      assert_select "form[action=?]", admin_meeting_path(meeting)
    end

    test "#edit returns 404 if meeting belongs to a different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      meeting = meetings(:football_club_training)

      get edit_admin_meeting_path(meeting)
      assert_response :not_found
    end

    test "#update succeeds for admin and updates meeting" do
      login_as users(:admin), on: platforms(:coffee_shop)
      meeting = meetings(:next_coffee_shop_board_meeting)
      new_title = "Updated Meeting Title"

      patch admin_meeting_path(meeting), params: {
        meeting: {
          title: new_title
        }
      }

      assert_response :success
      meeting.reload
      assert_equal new_title, meeting.title
    end

    test "#update returns errors when invalid data is submitted" do
      login_as users(:admin), on: platforms(:coffee_shop)
      meeting = meetings(:next_coffee_shop_board_meeting)

      patch admin_meeting_path(meeting), params: {
        meeting: {
          title: ""
        }
      }

      assert_response :unprocessable_content
      assert_select "form[action=?]", admin_meeting_path(meeting)
      assert_select ".form-error", text: /Title can't be blank/
    end

    test "#update returns 404 if meeting belongs to a different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      meeting = meetings(:football_club_training)

      patch admin_meeting_path(meeting), params: {
        meeting: {
          title: "New Title"
        }
      }

      assert_response :not_found
    end

    test "#destroy succeeds for admin, deletes meeting and redirects with notice" do
      login_as users(:admin), on: platforms(:coffee_shop)
      meeting = meetings(:next_coffee_shop_board_meeting)

      assert_difference -> { Meeting.count }, -1 do
        delete admin_meeting_path(meeting)
      end

      assert_redirected_to admin_meetings_path
      assert_equal "Meeting deleted", flash[:notice]
    end

    test "#destroy returns 404 if meeting belongs to a different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      meeting = meetings(:football_club_training)

      assert_no_difference -> { Meeting.count } do
        delete admin_meeting_path(meeting)
      end

      assert_response :not_found
    end

    test "#destroy returns 404 for member user" do
      login_as users(:member), on: platforms(:coffee_shop)
      meeting = meetings(:football_club_training)

      assert_no_difference -> { Meeting.count } do
        delete admin_meeting_path(meeting)
      end

      assert_response :not_found
    end
  end
end
