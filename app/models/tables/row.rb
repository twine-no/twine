module Tables
  class Row
    attr_reader :cells

    def initialize(columns)
      @cells = map_cells(columns)
    end

    private

    def map_cells(columns)
      @columns.map do |column|
        # You can specify table columns in two ways:
        # 1. As a string or symbol, which will be used as the column name
        # 2. As a hash, which will be used to specify a custom component or Proc
        case column
        when Hash
          if column[:text]
            handle_custom_column_type(
              {
                component: ->(record) { TableCells::TextComponent.new(column[:text].call(record)) },
                options:   column[:options] || {}
              }
            )
          else
            handle_custom_column_type(column)
          end
        when Proc
          handle_custom_column_type(column)
        when String, Symbol
          handle_generic_column_type(column)
        else
          raise "Unsupported column type: #{column.class}"
        end
      end
    end

    def handle_custom_column_type(column)
      return handle_generic_column_type(column.keys.first, column[:options]) if column[:component].nil?

      case column[:component].class.name
      when Proc.name
        {
          component: column[:component],
          options:   column[:options] || {}
        }
      else
        {
          component: ->(record) { column[:component].new(record) },
          options:   column[:options] || {}
        }
      end
    end

    # When no component is specified, we select a default component
    # based on the cell content class
    def handle_generic_column_type(column, options = {})
      {
        component: lambda { |record|
          cell_content = record.try(column)
          case cell_content.class.to_s
          when String.name, Symbol.name, NilClass.name, Integer.name
            cell_content = cell_content.to_s
            ::Text::Component.new.with_content(cell_content)
          when Date.name, Time.name, ActiveSupport::TimeWithZone.to_s # ActiveSupport::TimeWithZone.name returns Time-class
            ::TableCells::DatetimeComponent.new(cell_content) # inconsistent use of .with_content vs .new
          else
            raise "Not sure how to handle type! #{cell_content.class}"
          end
        },
        options:   options || {}
      }
    end
  end
end
