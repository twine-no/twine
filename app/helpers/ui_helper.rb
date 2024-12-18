module UiHelper
  def card(**options, &block)
    render "navigation/card", options: options, content: capture(&block)
  end

  def badge(text, color: "gray")
    render "navigation/badge", text: text, color: color
  end

  def sidebar_active_html_class(option_controller)
    "active" if controller_name == option_controller
  end

  def dropdown_menu(**options, &block)
    render "navigation/dropdown_menu", options: options, content: capture(&block)
  end

  def dropdown_menu_content(**options, &block)
    render "navigation/dropdown_menu_content", options: options, content: capture(&block)
  end
end
