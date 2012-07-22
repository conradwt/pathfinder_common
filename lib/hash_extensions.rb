class Hash
  
  def self.from_alist(alist)
    returning Hash.new do |result|
      alist.each do |key, value|
        result[key] = value
      end
    end
  end
  
  def self.from_lists(keys, values)
    return {} if keys.blank? or values.blank?
    returning Hash.new do |result|
      keys.each_with_index do |each, index|
        result[each] = values[index] if values.size > index
      end
    end
  end
  
  def map_to_list
    result = []
    self.each do |key, value|
      result << yield(key, value)
    end
    result
  end
  
  def sorted_by_value
    result = self.map { |key, value| [key, value] }
    result = result.sort_by { |key, value| -value }
  end
  
  def map_key
    result = {}
    each do |key, value|
      result[yield(key)] = value
    end
    result
  end
  
  def to_query_string
    map_to_list { |key, value| "#{key}=#{value}"}.join("&")
  end
  
end