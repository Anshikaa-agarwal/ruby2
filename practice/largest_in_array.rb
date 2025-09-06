class Array
  def largest
    return nil if self.empty?
    max_element = self[0]
    each do |val|
      raise ArgumentError, "No comparision with #{val.class}" unless val.is_a?Integer
      max_element = val if val > max_element
    end
    max_element
  end
end

arr = [1,2,3,4,"a",2]
begin
  p arr.largest
rescue ArgumentError => e
  puts e.message
end
