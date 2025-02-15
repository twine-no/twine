module Tables
  module FiltersHelper
    def table_filter_checkbox_checked?(checkbox_value, selected_filters)
      return false if selected_filters.nil?

      # We have to make an Array comparison to ensure:
      # 1) the checkbox is checked if its value is "admin, super_admin", and selected filters are "admin, super_admin, member"
      # 2) that we also prevent an "admin" box from being ticked if the selected filters are "super_admin"
      selected_filters_array = selected_filters.split(",")
      if checkbox_value.is_a?(Array)
        checkbox_value.all? { |value| value.in?(selected_filters_array) }
      else
        checkbox_value.in?(selected_filters_array)
      end
    end
  end
end
