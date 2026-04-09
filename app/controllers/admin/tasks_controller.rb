module Admin
  class TasksController < AdminController
    before_action :set_project
    before_action :set_task, only: %i[update destroy]

    def create
      @task = @project.tasks.new(task_params)

      if @task.save
        redirect_to admin_project_path(@project)
      else
        redirect_to admin_project_path(@project), alert: @task.errors.full_messages.to_sentence
      end
    end

    def update
      @task.update!(task_params)
      redirect_to admin_project_path(@project)
    end

    def destroy
      @task.destroy!
      redirect_to admin_project_path(@project)
    end

    private

    def set_project
      @project = Current.platform.projects.find(params[:project_id])
    end

    def set_task
      @task = @project.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :completed)
    end
  end
end
