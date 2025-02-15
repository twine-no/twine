module Admin
  class GroupsController < AdminController
    before_action :set_group, only: %i[edit update destroy]

    def new
      @group = Group.new
    end

    def create
      @group = Current.platform.groups.new(group_params)
      if @group.save
        redirect_to admin_memberships_path(tab: @group.id), notice: "Created #{@group.name}"
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit
    end

    def update
      if @group.update(group_params)
        redirect_to admin_memberships_path(tab: @group.id), notice: "#{@group.name} updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @group.destroy!
      redirect_to admin_memberships_path, notice: "#{@group.name} deleted"
    end

    private

    def set_group
      @group = Current.platform.groups.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name)
    end
  end
end
