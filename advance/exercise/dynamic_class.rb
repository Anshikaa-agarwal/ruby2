# frozen_string_literal: true

# module to take input
module Inputs
  def input(msg)
    print msg
    gets.chomp
  end

  def input_class_name
    class_name = input('Please enter the class name: ')
    raise ArgumentError, 'class name must start with uppercase' unless class_name[0] =~ /[A-Z]/

    class_name
  end

  def input_method_name
    method_name = input('Please enter the method name: ')
    raise ArgumentError, 'method name must not start with uppercase' if method_name[0] =~ /[A-Z]/

    method_name
  end

  def input_method_code
    input("Please enter the method's code: ")
  end
end

# included module input
class Object
  include Inputs
end

# class to generate class dynamically
class DynamicClass
  attr_reader :my_class

  def initialize(class_name)
    @my_class = Object.const_set(class_name, Class.new)
  end

  def def_method(method_name, method_body)
    @my_class.define_method(method_name) do
      instance_eval(method_body, 'dynamic_class.rb', 44)
    end
  end

  def call(method_name)
    puts "Hello, your class #{my_class} with method #{method_name} is ready."
    puts "Calling: #{my_class}.new.#{method_name}:"
    my_class.new.send(method_name)
  end
end

begin
  class_name = input_class_name
rescue ArgumentError => e
  puts "#{e.message} (#{e.class})"
  retry
end

begin
  method_name = input_method_name
rescue ArgumentError => e
  puts "#{e.message} (#{e.class})"
  retry
end

method_code = input_method_code

my_class = DynamicClass.new(class_name)
my_class.def_method(method_name, method_code)

begin
  my_class.call(method_name)
rescue StandardError => e
  puts "#{e.message} (#{e.class})"
end