module Admin
  class MembershipsController < AdminController
    before_action :set_membership, only: [ :show, :edit, :update, :destroy ]

    def new
      @membership = Membership.new
      @membership.build_user
      show_as_modal_inside :index
    end

    def create
      @membership = Current.platform.memberships.new(membership_params)
      @membership.user = find_or_invite_user(@membership.user)

      if @membership.save
        redirect_to admin_memberships_path, notice: "Invited #{@membership.user.first_name}"
      else
        show_as_modal_inside :index, modal_content_view: :new, status: :unprocessable_content
      end
    end

    def index
      set_data_table_page Current.platform.memberships.joins(:user),
                          allow_sort_by: %w[users.first_name users.last_name users.email]
    end

    def show
    end

    def edit
    end

    def update
      if @membership.update(membership_params.merge(membership_role_params))
        redirect_to admin_membership_path(@membership), notice: "Member saved."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      if @membership.user == Current.user
        return redirect_to admin_membership_path(@membership), notice: "You can't delete yourself!"
      end

      @membership.destroy!
      redirect_to admin_memberships_path, notice: "Deleted #{@membership.user.full_name}"
    end

    private

    def set_membership
      @membership = Current.platform.memberships.find(params[:id])
    end

    def membership_params
      params.require(:membership).permit(user_attributes: [ :id, :email, :first_name, :last_name ])
    end

    def membership_role_params
      return {} unless Current.user.has_super_admin_rights_at?(Current.platform)
      return {} if Current.user == @membership.user

      params.require(:membership).permit(:role)
    end

    def find_or_invite_user(user)
      existing_user = User.find_by(email: user.email)
      return existing_user if existing_user

      # User must reset their password when invited
      temporary_password = SecureRandom.base58
      user.password = temporary_password
      user
    end
  end
end
