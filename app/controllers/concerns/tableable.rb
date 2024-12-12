module Tableable
  extend ActiveSupport::Concern

  def set_data_table_page(records, default_sort_by: nil, default_sort_direction: nil, per_page: nil)
    records = search_for_records(records)
    order_query = set_sorting_settings(records, default_sort_by, default_sort_direction)

    set_page_and_extract_portion_from(
      records.order(Arel.sql(order_query)),
      per_page: per_page
    )
  end

  private

  def set_sorting_settings(records, default_sort_by, default_sort_direction)
    records_table_name = records.klass.table_name
    default_sort_direction = :asc if default_sort_direction.blank?
    default_sort_by = "#{records_table_name}.created_at" if default_sort_by.blank?

    sort_by_attribute = params[:sort_by].presence || default_sort_by
    sort_by_direction = (params[:sort_direction].presence || default_sort_direction)&.to_s&.downcase == "desc" ? "DESC" : "ASC"

    order_query = "#{sort_by_attribute} #{sort_by_direction} NULLS LAST"

    # Use ID as a tiebreaker to ensure no elements are loaded in several pages.
    order_query += ", #{records_table_name}.id #{sort_by_direction} NULLS LAST" unless sort_by_attribute.to_s == "id" || sort_by_attribute.to_s == "#{records_table_name}.id"

    order_query
  end

  def search_for_records(records)
    return records if params[:search_term].blank?
    return records unless records.klass.table_searchable?

    records.table_searchable_scope(params[:search_term])
  end
end
