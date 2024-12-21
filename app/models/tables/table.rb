module Tables
  class Table
    attr_reader :title, :guid,
                :rows, :columns, :headers, :actions,
                :sort_by, :sort_direction, :search_term, :filters, :tabs,
                :page, :collection, :no_results_placeholder

    def initialize(
      records,
      columns: [],
      params:,
      title: nil,
      sort_by: nil,
      sort_direction: nil,
      search_term: nil,
      searchable: false,
      multi_select: false,
      actions: [],
      tabs: [],
      exportable: false,
      turbo_streamable: false,
      update_address_bar: true,
      row_link_to: nil,
      no_results_placeholder: "No results yet",
      guid: nil
    )
      if records.is_a?(GearedPagination::Page)
        @page = records
      else
        @collection = records
      end

      @filters = []
      @columns = build_columns(columns)
      @headers = build_headers
      @tabs = build_tabs(tabs, params)
      @rows = (@page&.records || @collection).map { |record| Tables::Row.new(record, @columns, row_link_to: row_link_to) }
      @title = title
      @sort_by = sort_by&.to_s
      @sort_direction = sort_direction&.to_s
      @search_term = search_term
      @searchable = searchable # pass a String to specify the search field placeholder text
      @exportable = exportable
      @multi_select = multi_select
      @actions = actions
      @turbo_streamable = turbo_streamable
      @update_address_bar = update_address_bar
      @no_results_placeholder = no_results_placeholder
      @guid = guid || params[:table_guid] || SecureRandom.uuid
    end

    def turbo_frame_id
      "data_table_#{@guid}"
    end

    def build_headers
      @columns.map do |column|
        Tables::Header.new(
          column: column
        )
      end
    end

    def build_tabs(tab_array, params)

      tab_array.map do |tab|
        Tables::Tab.new(
          title: tab[0],
          value: tab[1],
          selected: params[:tab].presence == tab[1]
        )
      end
    end

    def search_placeholder
      return "Search ..." unless @searchable.is_a?(String)

      @searchable
    end

    def paginated?
      !!@page
    end

    def searchable?
      @searchable
    end

    def exportable?
      @exportable
    end

    def multi_select?
      @multi_select
    end

    def turbo_streamable?
      @turbo_streamable
    end

    def update_address_bar?
      @update_address_bar
    end

    def show_toolbar?
      title.present? || searchable? || exportable? || actions.any? || tabs.any?
    end

    # Ensures we include the multi select checkbox column in the column count
    def column_count
      columns_count = @columns.size
      columns_count += 1 if @multi_select
      columns_count
    end

    private

    def build_columns(columns)
      renderable_columns = columns.select do |column|
        raise "Column must be a Hash" unless column.is_a?(Hash)
        !column.key?(:render_if) || column[:render_if]
      end

      renderable_columns.map.with_index do |column, index|
        @filters << column[:filter_by] if column[:filter_by]

        Tables::Column.new(
          table: self,
          index: index,
          content: column[:content],
          header: column[:header],
          sort_by: column[:sort_by],
          filter_by: column[:filter_by],
          fixed: column[:fixed],
          options: column[:options]
        )
      end
    end
  end
end
