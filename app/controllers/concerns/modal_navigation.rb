module ModalNavigation
  extend ActiveSupport::Concern

  # Allows a modal view to be displayed inside another encapsulating view,
  # making it possible to go directly to the URL of a modal, and still have it render inside the surrounding page.
  # NB! This will not run before_actions for the modal view, meaning auth for the encapsulating view must work for modal view
  def render_as_modal_inside(encapsulating_view, modal_content_view: nil, status: nil, &block)
    return if turbo_frame_request?

    @modal_content = if modal_content_view
                       modal_content_view
                     else
                       "#{controller_path}/#{action_name}"
                     end

    # Used to render view inside the
    yield block if block_given?

    render encapsulating_view, { status: status }.compact
  end
end
