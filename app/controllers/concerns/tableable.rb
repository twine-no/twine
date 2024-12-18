module Tableable
  extend ActiveSupport::Concern

  def set_data_table_page(records, default_sort_by: nil, default_sort_direction: nil, per_page: nil)
    records = search_for_records(records)
    records = filter_records(records)
    order_query = set_sorting_settings(records, default_sort_by, default_sort_direction)
    set_page_and_extract_portion_from(
      records.order(Arel.sql(order_query)),
      per_page: per_page
    )
  end

  private

  def set_sorting_settings(records, default_sort_by, default_sort_direction)
    default_sort_direction = :asc if default_sort_direction.blank?
    order_query = ""
    sanitized_sort_by_direction = sanitize_sort_by_direction(default_sort_direction)

    sanitize_sort_by_attributes(default_sort_by || "#{records.klass.table_name}.created_at", records.klass).each do |sanitized_sort_by_attribute|
      order_query += "#{sanitized_sort_by_attribute} #{sanitized_sort_by_direction} NULLS LAST, "
    end

    # Use ID as a tiebreaker to ensure no elements are loaded on several pages.
    order_query += "#{records.klass.table_name}.id #{sanitized_sort_by_direction} NULLS LAST"
    order_query
  end

  def filter_records(records)
    return records if params[:filters].blank?
    return records unless records.klass.respond_to?(:table_filter_by)

    records.table_filterable_scope(params[:filters])
  end

  def search_for_records(records)
    return records if params[:search_term].blank?
    return records unless records.klass.table_searchable?

    records.table_searchable_scope(params[:search_term])
  end

  def sanitize_sort_by_attributes(default_sort_by, records_class)
    return [ default_sort_by ] unless params[:sort_by].present?

    sort_by_params = params[:sort_by].split(",")
    sort_by_params.select do |sort_by_param|
      sort_by_param.to_sym.in?(records_class.table_sortable_attributes)
    end
  end

  def sanitize_sort_by_direction(default_sort_direction)
    (params[:sort_direction].presence || default_sort_direction)&.to_s&.downcase == "desc" ? "DESC" : "ASC"
  end
end
