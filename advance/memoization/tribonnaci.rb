# Create a class MathSeries with a memoized method tribonacci(n) (like Fibonacci but sum of last 3 numbers).

class Series
  def tribonacci(n)
    @trib ||= {}
    @trib[n] ||= begin
      sleep(0.4)
      return 0 if n==0
      return 1 if n < 3
      tribonacci(n - 1) + tribonacci(n - 2) + tribonacci(n - 3)
    end
  end
end

s = Series.new
p s.tribonacci(4)
p s.tribonacci(5)
p s.tribonacci(6)
p s.tribonacci(7)