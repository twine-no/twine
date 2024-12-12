# frozen_string_literal: true

module Tables
  module Searchable
    extend ActiveSupport::Concern

    class_methods do
      def table_searchable?
        respond_to?(:table_searchable_scope)
      end
    end
  end
end
