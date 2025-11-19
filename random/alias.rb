class Integer
  alias :sum_plus_one :+
  def +(num)
    self.sum_plus_one(1).sum_plus_one(num)
  end
end
puts 1+1