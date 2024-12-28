# frozen_string_literal: true

module Tables
  module SupportsAdvancedQueries
    extend ActiveSupport::Concern

    @@table_filterable_attributes = nil
    @@table_sortable_attributes = nil

    included do
      # By default, models do not respond to tabs
      scope :by_table_tab, ->(_tab) do
        self
      end

      scope :table_filterable_scope, ->(filter_params) do
        sanitized_filter_params = {}
        filter_params.each do |filter_param_key, filter_param_value|
          filter_param_key = filter_param_key.to_s
          table_name, attribute_name = filter_param_key.split(".")
          filter_class = table_name.classify.safe_constantize
          next unless filter_class.respond_to?(:table_filter_by)

          if filter_class.table_filterable_attributes.include?(attribute_name)
            filter_value = filter_param_value.to_s.split(",")

            # If no value is set, then no filter should be applied.
            # That means if checkboxes checked => show all records
            next unless filter_value.present?

            sanitized_filter_params[filter_param_key] = filter_value
          end
        end
        where(sanitized_filter_params)
      end
    end

    class_methods do
      def table_filter_by(attributes)
        @@table_filterable_attributes = attributes
      end

      def table_filterable_attributes
        @@table_filterable_attributes
      end

      def table_searchable?
        respond_to?(:table_searchable_scope)
      end
    end
  end
end
