module NavigationHelper
  def sidebar_active_html_class(option_controller)
    'active' if controller_name == option_controller
  end
end
