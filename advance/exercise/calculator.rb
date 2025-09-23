# frozen_string_literal: true

module Convertor
  def str_to_sym(str)
    str.tr(':', '').to_sym
  end
  def str_to_int(str)
    str.to_i
  end
end

module Calculation
  def arithmetic_op(first, operator, second)
    first.send(operator, second)
  end
end

class Evaluator
  include Convertor
  include Calculation

  def parse_inputs(input)
    first_str, op_str, second_str = input.split(",")
    

  def calculate(**args)
    # first_str, op_str, second_str = input.split(",")
    # first  = str_to_int(first_str)
    # second = str_to_int(second_str)
    # operator = str_to_sym(op_str)

    # arithmetic_op(first, operator, second)

    
  end
end

if ARGV.empty?
  puts 'Please provide an input'
else
  evaluator = Evaluator.new
  input = ARGV[0]
  puts evaluator.calculate(input)
end
