# Create a class Calculator and dynamically define methods add, subtract, multiply, divide.
class Calculator
  class << self   # opens the singleton class for class methods
    operations_hash = {
      add: :+,
      subtract: :-,
      multiply: :*,
      divide: :/
    }

    operations_hash.each do |operation, operator|
      define_method(operation) do |first, second|
        first.send(operator, second)
      end
    end
  end
end

# Usage
puts Calculator.add(2, 3)      # 5
puts Calculator.multiply(4, 5) # 20
