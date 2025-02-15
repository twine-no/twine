module Tables
  class Column
    attr_reader :table, :index, :content, :header, :sort_by, :filters, :fixed, :options

    alias title header

    def initialize(table:, index:, content:, header:, sort_by:, filter_by:, fixed:, options:)
      @table = table
      @index = index
      @content = content
      @header = header
      @sort_by = sort_by
      @filters = filter_by
      @fixed = fixed
      @options = options
    end

    def sortable?
      @sort_by.present?
    end

    def filterable?
      filters&.any?
    end

    def selected?
      @sort_by == table.sort_by
    end

    def fixed?
      !!@fixed
    end

    def sort_direction
      return "neutral" unless selected?

      table.sort_direction == "desc" ? "desc" : "asc"
    end
  end
end
