module Tables
  class Row
    attr_reader :record, :cells, :url

    def initialize(record, columns, row_link_to:)
      @record = record
      @cells = map_cells(columns)

      # Supports static URL as string and dynamic URL as proc
      @url = row_link_to.is_a?(Proc) ? row_link_to.call(@record) : row_link_to
    end

    private

    def map_cells(columns)
      columns.map do |column|
        handle_custom_column_type(column)
      end
    end

    # Used when the implementation specifies a content hash, typically with a Proc
    # I.e. { content: -> { some_content } }
    def handle_custom_column_type(column)
      case column.content.class.name
      when Proc.name
        {
          content: column.content,
          options: column.options || {}
        }
      else
        {
          content: ->(record) { column.content.new(record) },
          options: column.options || {}
        }
      end
    end
  end
end
