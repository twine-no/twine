module Tables
  class Table
    attr_accessor :title, :guid, :sort_by, :sort_direction, :search_term, :page, :collection

    def initialize(
      records,
      columns: [],
      params:,
      title:,
      sort_by: nil,
      sort_direction: nil,
      search_term: nil,
      searchable: false,
      multi_select: false,
      exportable: false,
      has_toolbar: true,
      changes_url: false,
      guid: nil
    )
      if records.is_a?(GearedPagination::Page)
        @page = records
      else
        @collection = records if @page.nil?
      end

      @columns = columns.reject { |column| column.is_a?(Hash) && column.key?(:render_if) && !column[:render_if] }
      @title = title
      @sort_by = sort_by&.to_s
      @sort_direction = sort_direction&.to_s
      @search_term = search_term
      @searchable = searchable # pass a String to specify the search field placeholder text
      @exportable = exportable
      @multi_select = multi_select
      @has_toolbar = has_toolbar
      @changes_url = changes_url
      @guid = guid || params[:guid] || SecureRandom.uuid
    end

    def html_id
      @guid
    end

    def turbo_frame_id
      "data_table_#{@guid}"
    end

    def headers
      @columns.map do |column|
        if column.is_a?(Hash)
          header_title = if column[:header].nil?
                           column.keys.first
                         else
                           column[:header]
                         end
          header_sort_by = column[:sort_by]
          header_fixed = column[:fixed]
        else
          header_title = column.to_s.humanize
          header_sort_by = nil
          header_fixed = false
        end

        Tables::Header.new(
          title: header_title,
          sort_by: header_sort_by&.to_s,
          fixed: header_fixed
        )
      end
    end

    def rows
      @page&.records || @collection
    end

    def search_placeholder
      return nil unless @searchable.is_a?(String)

      @searchable
    end

    def paginated?
      !!@page
    end

    def searchable?
      !!@searchable
    end

    def exportable?
      !!@exportable
    end

    def multi_select?
      !!@multi_select
    end

    def has_toolbar?
      !!@has_toolbar
    end

    def changes_url?
      !!@changes_url
    end

    # Ensures we include the multi select checkbox column in the column count
    def column_count
      columns_count = @columns.size
      columns_count += 1 if @multi_select
      columns_count
    end
  end
end
