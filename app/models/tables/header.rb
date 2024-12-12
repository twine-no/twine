module Tables
  class Header
    attr_accessor :title, :sort_by

    def initialize(title:, sort_by:, fixed:)
      @title = title
      @sort_by = sort_by
      @fixed = fixed
    end

    def fixed?
      !!@fixed
    end
  end
end
