module Admin
  class OnboardingsController < AdminController
    skip_before_action :ensure_user_is_onboarded
    before_action :redirect_if_already_onboarded

    layout 'onboarding'

    def show
      @session = Current.session
      @session.build_platform
    end

    def update
      @session = Current.session

      if @session.onboard_user(session_params)
        redirect_to root_path, notice: 'Welcome!'
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def session_params
      params.require(:session).permit(
        user_attributes: [:id, :first_name, :last_name],
        platform_attributes: [:name]
      )
    end

    def redirect_if_already_onboarded
      redirect_to root_path if Current.session.onboarded?
    end
  end
end
