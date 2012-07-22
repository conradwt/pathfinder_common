class Time
  def smart_to_date
    to_date
  end
end

class Date
  
  # returns a sunday to sunday week range suitable to be passed to an
  # SQL statement
  def to_week_range
    sunday = self.beginning_of_week.yesterday
    sunday .. (sunday + 7)
  end
  
  def to_month_range
    self.beginning_of_month .. (1.month.since(self.beginning_of_month))
  end
  
  def self.parse_or_nil(string, comp = false)
    parse(string, comp)
  rescue ArgumentError
    nil
  end
  
  def smart_to_date
    self
  end
  
  def self.smart_parse(string, default = nil, comp = false)
    default ||= Date.today
    return default if string.blank?
    date = Chronic.parse(string, :context => :past) ||
           Chronic.parse(string.gsub(",", " "), :context => :past) ||
           Date.parse_or_nil(string, comp) ||
           default
    return default if date.blank?
    date.to_date
  end
end

class String
  
  def smart_to_date
    Date.smart_parse(self)
  end
  
end