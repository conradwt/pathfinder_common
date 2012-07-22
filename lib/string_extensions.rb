class String
  
  def is_true?
    %w(true t 1).include?(self.to_s.downcase)
  end
  
  # def to_hash(external_delim, internal_delim)
  #   result = HashWithIndifferentAccess.new
  #   pair_strings = split(external_delim)
  #   pair_strings.each do |pair|
  #     key, value = pair.split(internal_delim)
  #     result[key] = value
  #   end
  #   result
  # end
  
  def smart_to_i
    i = self.to_i
    if i == 0
      if self == "0" then return 0 else return self end
    end
    return i
  end

  def self.random_string(len)
    (1..len).map {String.alphanumeric_characters.rand}.join
  end

  def self.alphanumeric_characters
    ("A".."Z").to_a + ("a".."z").to_a + ("0".."9").to_a
  end
  
  def possessive
    self.last == 's' ? (self + "\'") : (self + "\'s")
  end

end