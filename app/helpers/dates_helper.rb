module DatesHelper
  def datetime_format(datetime, format: :datetime)
    return nil if datetime.nil?

    datetime_pattern =
      case format
      when :date
        "%d %B, %Y"
      when :time
        "%H:%M"
      when :datetime
        "%d %B, %Y %H:%M"
      when :html_datetime
        "%Y %M %d %H:%M"
      when :simple_date
        "%d %B"
      when :only_date
        datetime.day == 1 ? "%d %B" : "%d"
      when :pretty_datetime
        if datetime.year == Time.current.year
          "%A %d %B, %H:%M"
        else
          "%A %d %B, %Y %H:%M"
        end
      else
        raise "Unknown format: #{format}"
      end

    datetime.strftime(datetime_pattern)
  end
end
