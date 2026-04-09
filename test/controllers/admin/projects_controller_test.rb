require "test_helper"

module Admin
  class ProjectsControllerTest < ActionDispatch::IntegrationTest
    test "#index succeeds for admin" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get admin_projects_path
      assert_response :success
    end

    test "#index returns 404 for member" do
      login_as users(:member), on: platforms(:coffee_shop)
      get admin_projects_path
      assert_response :not_found
    end

    test "#show succeeds" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get admin_project_path(projects(:coffee_shop_website_relaunch))
      assert_response :success
    end

    test "#show returns 404 if project belongs to a different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get admin_project_path(projects(:football_club_kit_order))
      assert_response :not_found
    end

    test "#new succeeds" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get new_admin_project_path
      assert_response :success
    end

    test "#create succeeds and redirects to project" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_difference -> { Project.count }, 1 do
        post admin_projects_path, params: { project: { title: "New Project" } }
      end
      assert_redirected_to admin_project_path(Project.last)
      assert_equal "New Project created", flash[:notice]
    end

    test "#create renders errors when title is blank" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_no_difference -> { Project.count } do
        post admin_projects_path, params: { project: { title: "" } }
      end
      assert_response :unprocessable_content
    end

    test "#edit succeeds" do
      login_as users(:admin), on: platforms(:coffee_shop)
      get edit_admin_project_path(projects(:coffee_shop_website_relaunch))
      assert_response :success
    end

    test "#update succeeds and redirects to project" do
      login_as users(:admin), on: platforms(:coffee_shop)
      project = projects(:coffee_shop_website_relaunch)
      patch admin_project_path(project), params: { project: { title: "Renamed" } }
      assert_redirected_to admin_project_path(project)
      assert_equal "Renamed", project.reload.title
    end

    test "#update returns 404 if project belongs to a different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      patch admin_project_path(projects(:football_club_kit_order)), params: { project: { title: "x" } }
      assert_response :not_found
    end

    test "#destroy succeeds and redirects to index" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_difference -> { Project.count }, -1 do
        delete admin_project_path(projects(:coffee_shop_website_relaunch))
      end
      assert_redirected_to admin_projects_path
    end

    test "#destroy returns 404 if project belongs to a different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_no_difference -> { Project.count } do
        delete admin_project_path(projects(:football_club_kit_order))
      end
      assert_response :not_found
    end
  end
end
