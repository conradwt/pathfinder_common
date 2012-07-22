class Integer
  def to_active_record(ar_class)
    ar_class.find(self)
  end
  
  def to_active_record_id
    self
  end
end

module ActiveRecord
  class Base
    def to_active_record(ar_class)
      self
    end
    
    def to_active_record_id
      self.id
    end
  end
end
