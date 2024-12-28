module DatesHelper
  def datetime_format(datetime, format: :datetime)
    return nil if datetime.nil?

    datetime_pattern = case format
    when :date
                         "%d %B, %Y"
    when :time
                         "%H:%M"
    when :datetime
                         "%d %B, %Y %H:%M"
    end

    datetime.strftime(datetime_pattern)
  end
end
