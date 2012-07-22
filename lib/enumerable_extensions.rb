module Enumerable
  # group the values into a hash, where the key is specified by the passed block
  def group_into_hash
    returning Hash.new do |groups|
      each do |element|
        (groups[yield(element)] ||= []) << element 
      end
    end
  end
  
  def frequency_histogram
    returning Hash.new do |groups|
      each do |element|
        value = yield(element)
        groups[value] ||= 0
        groups[value] += 1 
      end
    end
  end
  
  # def to_hash
  #   result = {}
  #   each do |i| 
  #     result[yield(i)] = i
  #   end
  #   return result
  # end
  
  def to_value_hash
    result = {}
    each do |i| 
      result[i] = yield(i)
    end
    return result
  end
  
  def lowest_missing_number(start = 1)
    return start unless self.include?(start)
    lowest_missing_number(start + 1)
  end

  def to_id_hash
    result = {}
    each do |i|
      result[i.id] = yield(i)
    end
    result
  end
  
  def none?(&block)
    !any?(&block)
  end

  
end