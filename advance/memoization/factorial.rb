class Series
  def factorial(n)
    @fact ||= {}
    @fact[n] ||= begin
      sleep(0.5)
      return 1 if n<2
      n*factorial(n-1)
    end
  end
end

s = Series.new
p s.factorial(5)
p s.factorial(6)