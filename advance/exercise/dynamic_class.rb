# frozen_string_literal: true

# custom error class for constant validation
class ConstantError < StandardError
  def initialize(msg = 'Input must be a constant')
    super(msg)
  end
end

# custom error class for method name validation
class MethodNameError < StandardError
  def initialize(msg = 'Method name must start with lowercase')
    super(msg)
  end
end

module Inputs
  UPPERCASE_LETTER = /[A-Z]/.freeze
  def input(msg)
    print msg
    gets.chomp
  end

  def input_class_name
    class_name = input('Please enter the class name: ')
    raise ConstantError unless class_name[0] =~ UPPERCASE_LETTER

    class_name
  end

  def input_method_name
    method_name = input('Please enter the method name: ')
    raise MethodNameError if method_name[0] =~ UPPERCASE_LETTER

    method_name
  end

  def input_method_code
    input("Please enter the method's code: ")
  end
end

# class to generate class dynamically
class DynamicClass
  include Inputs
  attr_reader :my_class

  def initialize
    class_name = take_class_name
    @my_class = Object.const_set(class_name, Class.new)
  end

  def take_class_name
    input_class_name
  rescue ConstantError => e
    puts "#{e.message} (#{e.class})"
    retry
  end

  def take_method_name
    input_method_name
  rescue MethodNameError => e
    puts "#{e.message} (#{e.class})"
    retry
  end

  def take_method_body
    input_method_code
  end

  def def_method(method_name, method_body)
    @my_class.define_method(method_name) do
      instance_eval(method_body)
    end
  end

  def call(method_name)
    puts "Hello, your class #{my_class} with method #{method_name} is ready."
    puts "Calling: #{my_class}.new.#{method_name}:"
    my_class.new.send(method_name)
  end
end


my_class = DynamicClass.new
method_name = my_class.take_method_name
method_code = my_class.take_method_body
my_class.def_method(method_name, method_code)

begin
  my_class.call(method_name)
rescue StandardError => e
  puts "#{e.message} (#{e.class})"
end