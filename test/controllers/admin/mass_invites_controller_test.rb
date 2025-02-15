require "test_helper"

module Admin
  class MassInvitesControllerTest < ActionDispatch::IntegrationTest
    test "#create succeeds when inviting group, enqueues invite job" do
      login_as users(:admin), on: platforms(:coffee_shop)

      assert_difference -> { meetings(:next_coffee_shop_board_meeting).invites.count }, groups(:coffee_shop_board).memberships.count do
        perform_enqueued_jobs do
          post admin_meeting_mass_invites_path(meeting_id: meetings(:next_coffee_shop_board_meeting).id),
               params: {
                 group_id: groups(:coffee_shop_board).id
               }
        end
        assert_performed_with(job: Meetings::MassInviteJob)
        assert_redirected_to admin_meeting_path(meetings(:next_coffee_shop_board_meeting))
      end
    end

    test "#create invites entire platform when no group ID is specified" do
      login_as users(:admin), on: platforms(:coffee_shop)

      assert_difference -> { meetings(:next_coffee_shop_board_meeting).invites.count }, platforms(:coffee_shop).memberships.count do
        perform_enqueued_jobs do
          post admin_meeting_mass_invites_path(meeting_id: meetings(:next_coffee_shop_board_meeting).id)
        end
        assert_performed_with(job: Meetings::MassInviteJob)
        assert_redirected_to admin_meeting_path(meetings(:next_coffee_shop_board_meeting))
      end
    end

    test "#create doesn't allow you to invite to meeting belonging to other different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      post admin_meeting_mass_invites_path(meeting_id: meetings(:next_political_chapter_board_meeting).id),
           params: {
             group_id: groups(:political_chapter_board)
           }
      assert_response :not_found
    end

    test "#create doesn't allow you to invite group belonging to other platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      post admin_meeting_mass_invites_path(meeting_id: meetings(:next_coffee_shop_board_meeting).id),
           params: {
             group_id: groups(:political_chapter_board)
           }
      assert_response :not_found
    end
  end
end
