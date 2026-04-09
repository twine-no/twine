require "test_helper"

module Admin
  class TasksControllerTest < ActionDispatch::IntegrationTest
    test "#create succeeds and redirects to project" do
      login_as users(:admin), on: platforms(:coffee_shop)
      project = projects(:coffee_shop_website_relaunch)
      assert_difference -> { Task.count }, 1 do
        post admin_project_tasks_path(project), params: { task: { title: "New task" } }
      end
      assert_redirected_to admin_project_path(project)
    end

    test "#create returns 404 if project belongs to a different platform" do
      login_as users(:admin), on: platforms(:coffee_shop)
      assert_no_difference -> { Task.count } do
        post admin_project_tasks_path(projects(:football_club_kit_order)), params: { task: { title: "x" } }
      end
      assert_response :not_found
    end

    test "#update succeeds and toggles task completion" do
      login_as users(:admin), on: platforms(:coffee_shop)
      task = tasks(:website_relaunch_design)
      patch admin_project_task_path(task.project, task), params: { task: { completed: true } }
      assert_redirected_to admin_project_path(task.project)
      assert task.reload.completed
    end

    test "#destroy succeeds and redirects to project" do
      login_as users(:admin), on: platforms(:coffee_shop)
      task = tasks(:website_relaunch_design)
      project = task.project
      assert_difference -> { Task.count }, -1 do
        delete admin_project_task_path(project, task)
      end
      assert_redirected_to admin_project_path(project)
    end
  end
end
