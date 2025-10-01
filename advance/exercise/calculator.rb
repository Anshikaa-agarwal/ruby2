# frozen_string_literal: true

# convert float to integer if number is integer
class Float
  def convert_if_integer
    temp = Integer(self)
    self == temp ? temp : self
  end
end

# class to evalute string
class Calculator
  attr_reader :first, :operand, :second
  VALID_OPERANDS = [:+, :-, :/, :*, :**]

  def initialize(*args)
    raise ArgumentError, "Expected 3 arguments: number, operator, number" unless args.size == 3

    @first = parse_number(args[0])
    @operand = parse_operand(args[1])
    @second = parse_number(args[2])
  end

  def evaluate
    result = first.public_send(operand, second)
    raise ZeroDivisionError, "Can not divide by 0" if second.zero? && operand == :/

    result.convert_if_integer
  end

  private

  def parse_number(num)
    Float(num)
  rescue ArgumentError
    raise ArgumentError, "Input must be Numeric"
  end

  def parse_operand(val)
    sym = val.tr(':', '').to_sym
    raise ArgumentError, "Operand must be #{VALID_OPERANDS}" unless VALID_OPERANDS.include?(sym)
    sym
  end
end

if ARGV.empty?
  puts 'Please provide an input'
else
  begin
    inputs = ARGV[0].split(',').map(&:strip)
    calc1 = Calculator.new(*inputs)
    puts calc1.evaluate
  rescue StandardError => e
    puts "#{e.message} (#{e.class})"
  end
end