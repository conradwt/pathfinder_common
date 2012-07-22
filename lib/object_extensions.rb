class Object
  
  def if_not_nil(&block)
    yield(self) if block
  end

  def if_nil(&block)
  end
  
  def in?(*enumerable)
    enumerable.flatten.include?(self)
  end
    
  def not_in?(*enumerable)
    !in?(*enumerable)
  end
  
  def not_blank?
    !blank?
  end
  
  def truthy?
    !blank?
  end
  
  def present?
    !blank?
  end
  
  # def to_hash(*keys)
  #   returning Hash.new do |result|
  #     keys.each do |key|
  #       result[key] = send(key)
  #     end
  #   end
  # end
  
end

class NilClass
  
  def is_true?    
    false
  end
  
  def smart_to_i
    0
  end
  
  def if_not_nil(&block)
  end

  def if_nil(&block)
    yield if block
  end

end