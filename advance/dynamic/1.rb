# Write a loop that asks the user which operation (add, subtract, multiply) and then uses send to call it.
class Calculator
  def add(x, y) = x + y
  def subtract(x, y) = x - y
  def multiply(x, y) = x * y
  def divide(x, y)
    raise ZeroDivisionError, "Cannot divide by 0!" if y == 0
    x / y
  end
end

def input(str)
  print str
  gets.chomp
end

calc = Calculator.new
operations = Calculator.public_instance_methods(false)

loop do
  method_to_call = input("Enter operation (#{operations.join(', ')}, exit): ").strip.downcase
  
  if method_to_call == 'exit'
    break
  else
    begin
      raise NoMethodError, 'No method found' unless calc.respond_to?(method_to_call)
      first = input("Operand 1: ").to_i
      second = input("Operand 2: ").to_i
      result = calc.send(method_to_call, first, second)
      puts result

    rescue => e
      puts e.message
    end
  end
end