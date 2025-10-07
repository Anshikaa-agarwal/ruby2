# frozen_string_literal: true

# calculator class
class Calculator
  NUMERICAL = /^\d+(\.\d+)?$/.freeze
  OPERAND = /^\:[+\-*\/]$/.freeze

  def self.evaluate(str)
    first, operand, second = validate(str)
    raise ZeroDivisionError if operand == :/ && second.zero?

    convert_op(first.send(operand, second))
  end

  def self.parse(str)
    str.split(',').map(&:strip)
  end

  def self.validate(str)
    first, operand, second = parse(str)
    raise ArgumentError, 'Invalid numeric value' unless [first, second].all? { |num| num.match?(NUMERICAL) }
    raise ArgumentError, 'Invalid numeric value' unless operand.match?(OPERAND)

    [first.to_f, operand.delete(':').to_sym, second.to_f]
  end

  def self.convert_op(output)
    int = output.to_i
    output == int ? int : output
  end
end

if ARGV.empty? || ARGV[0].strip.empty?
  puts 'Please provide an input'
else
  input = ARGV[0]
  puts Calculator.evaluate(input)
end