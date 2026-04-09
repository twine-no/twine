module Admin
  class TasksController < AdminController
    before_action :set_project
    before_action :set_task, only: %i[update destroy]

    def create
      @task = @project.tasks.new(task_params)

      if @task.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.append(:tasks, partial: "admin/tasks/task", locals: { task: @task, project: @project })
          end
          format.html { redirect_to admin_project_path(@project) }
        end
      else
        redirect_to admin_project_path(@project), alert: @task.errors.full_messages.to_sentence
      end
    end

    def update
      @task.update!(task_params)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@task, partial: "admin/tasks/task", locals: { task: @task, project: @project })
        end
        format.html { redirect_to admin_project_path(@project) }
      end
    end

    def destroy
      @task.destroy!

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@task) }
        format.html { redirect_to admin_project_path(@project) }
      end
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
