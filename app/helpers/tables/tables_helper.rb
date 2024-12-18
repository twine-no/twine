module Tables
  module TablesHelper
    def table_of(records, columns: [], **options)
      (@sort_by || params[:sort_by]).to_s.presence

      table = Tables::Table.new(
        records,
        params: params,
        columns: columns,
        sort_by: options[:sort_by] || params[:sort_by],
        sort_direction: options[:sort_direction] || params[:sort_direction],
        search_term: options[:search_term] || params[:search_term],
        **options
      )
      render "tables/table", table: table
    end
  end
end
