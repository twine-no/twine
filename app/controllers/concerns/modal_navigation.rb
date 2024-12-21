module ModalNavigation
  extend ActiveSupport::Concern

  # Allows a modal view to be displayed inside another encapsulating view,
  # making it possible to go directly to the URL of a modal, and still have it render inside the surrounding page.
  # NB! This will not run before_actions for the modal view, meaning auth for the encapsulating view must work for modal view
  def show_as_modal_inside(encapsulating_action, encapsulating_view: nil, modal_content_view: nil, status: nil)
    return if turbo_frame_request?

    public_send(encapsulating_action)
    @modal_content = if modal_content_view
                       modal_content_view.to_s.include?("/") ? modal_content_view : "#{controller_path}/#{modal_content_view}"
    else
                       "#{controller_path}/#{action_name}"
    end
    @encapsulating_view_url = url_for(controller: controller_name, action: encapsulating_action)
    options = { status: status }.compact
    render encapsulating_view || encapsulating_action, options
  end
end
