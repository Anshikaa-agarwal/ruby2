# fibonacci
class Series
  def fibonacci(n)
    @fib ||= {}
    @fib[n] ||= begin
      sleep(0.5)
      return 1 if n < 2
      fibonacci(n - 1) + fibonacci(n - 2)
    end
  end
end

s = Series.new
p s.fibonacci(3)
p s.fibonacci(4)


-> (a).class
-> (a).class
-> (a) {}.class
-> (a) {a}['Hello World'].class
-> (a)
-> (a) {}
-> (a) {a}['Hello World']
