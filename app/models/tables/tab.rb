module Tables
  class Tab
    attr_reader :title, :value, :html_options

    def initialize(title:, value:, selected:)
      @title = title
      @value = value
      @selected = selected
      @html_options = generate_html_options
    end

    def selected?
      @selected
    end

    private

    def generate_html_options
      default_options = {
        data: {
          action: "tables--tabs#changeTab",
          "tables--tabs-target": "tab",
          tab: @value
        }
      }
      default_options["aria_current"] = "page" if selected?
      default_options
    end
  end
end
