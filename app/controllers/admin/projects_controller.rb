module Admin
  class ProjectsController < AdminController
    before_action :set_project, only: %i[show edit update destroy]

    def index
      @projects = Current.platform.projects.includes(:tasks).order(:title)
    end

    def show
      @tasks = @project.tasks.order(completed: :asc, created_at: :asc)
      @new_task = Task.new
    end

    def new
      @project = Project.new
    end

    def create
      @project = Current.platform.projects.new(project_params)

      if @project.save
        redirect_to admin_project_path(@project)
      else
        redirect_to admin_projects_path, alert: @project.errors.full_messages.to_sentence
      end
    end

    def edit
    end

    def update
      if @project.update(project_params)
        redirect_to admin_project_path(@project), notice: "#{@project.title} updated"
      else
        render_inside_modal :edit, status: :unprocessable_content
      end
    end

    def destroy
      @project.destroy!
      redirect_to admin_projects_path, notice: "#{@project.title} deleted"
    end

    private

    def set_project
      @project = Current.platform.projects.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:title, :description)
    end
  end
end
