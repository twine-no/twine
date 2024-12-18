module Tables
  class Header
    attr_reader :column

    delegate :table, :title, to: :column

    def initialize(column:)
      @column = column
    end

    def sort_direction_icon_name
      case column.sort_direction&.to_sym
      when :asc
        "icons/mingcute/arrows/up_small_fill.svg"
      when :desc
        "icons/mingcute/arrows/down_small_fill.svg"
      else
        "icons/mingcute/arrows/selector_vertical_fill.svg"
      end
    end

    def sort_direction_class_name
      table.sort_direction&.to_sym == :neutral ? "w-6 h-6" : "w-4 h-4"
    end
  end
end
