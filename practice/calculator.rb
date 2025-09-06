class Calculator
  attr_reader :num1, :num2, :operator

  def initialize(num1, num2, operator)
    @num1 = num1.to_f
    @num2 = num2.to_f
    @operator = operator
  end

  def calculate
    case self.operator
    when '+'
      self.num1 + self.num2
    when '-'
      self.num1 - self.num2
    when '*'
      self.num1 * self.num2
    when '/'
      self.num1 / self.num2
    when '%'
      self.num1 % self.num2
    when '^'
      self.num1 ** self.num2
    end
  end
end

c = Calculator.new(12, 5, '/')
puts c.calculate