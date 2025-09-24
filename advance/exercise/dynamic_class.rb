# frozen_string_literal: true

# methods to take inputs
module Inputs
  def input(msg)
    print msg
    gets.chomp
  end

  def input_class_name
    input('Please enter the class name: ')
  end

  def input_method_name
    input('Please enter the method name you wish to define: ')
  end

  def input_method_code
    input("Please enter the method's code: ")
  end
end

class Object
  include Inputs
end

# create class dynamically
class DynamicClass
  attr_reader :my_class

  def initialize(class_name)
    @my_class = Object.const_set(class_name, Class.new)
  end

  def def_method(method_name, method_body)
    my_class.define_method(method_name) do
      instance_eval(method_body)
    end
  end

  def call(method_name)
    puts "Hello, Your class #{my_class} with method #{method_name} is ready."
    puts "Calling: #{my_class}.new.#{method_name}:"
    my_class.new.send(method_name)
  end
end

class_name  = input_class_name
method_name = input_method_name
method_code = input_method_code

my_class = DynamicClass.new(class_name)
my_class.def_method(method_name, method_code)
my_class.call(method_name)