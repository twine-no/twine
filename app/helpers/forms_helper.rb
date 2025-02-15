module FormsHelper
  def searchable_select(form, method, options, select_options = {}, html_options = {})
    selected = form.object.send(method) if form
    name = form ? "#{form.object_name}[#{method}]" : method

    # Render the partial with locals
    render partial: "forms/searchable_select", locals: {
      name: name,
      selected: selected,
      options: options,
      select_options: select_options,
      html_options: html_options
    }
  end
end
