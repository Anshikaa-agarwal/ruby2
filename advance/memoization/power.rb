class Operations
  def power(a,b)
    @powers ||= {}
    key = @powers[a]
  end
end

s = Operations.new
p s.power(2,3)
p s.power(2,3)