module ModalNavigation
  extend ActiveSupport::Concern

  def render_inside_modal(view, status:)
    render turbo_stream: turbo_stream.replace(
      :modal_content,
      inline:
        render_to_string(
          view,
          layout: false
        ),
      status: status
    )
  end
end
