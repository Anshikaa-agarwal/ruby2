# frozen_string_literal: true

# methods to take inputs
module TakeInputs
  def input(msg)
    print msg
    gets.chomp
  end

  def input_string
    input('Enter string: ')
  end

  def choose_method(class_name)
    puts 'List of methods defined:'
    p class_name.instance_methods(false)
    method_name = input('Choose a method: ')

    raise ArgumentError, 'Invalid method chosen' unless class_name.instance_methods.include?(method_name.to_sym)

    method_name
  end

  def input_complete_method(obj)
    method_name = choose_method(obj.class)
    method_to_call = obj.method(method_name)
    args = []

    args = input_args(method_to_call) if method_to_call.arity != 0

    [method_name, args]
  end

  def input_args(method)
    params = method.parameters

    puts "This method requires #{params.size} argument(s):"
    args = []

    params.each do |param|
      value = input("Enter value for '#{param[1]}' (#{param[0] == :req ? 'required' : param[0] == :opt ? 'optional' : 'nil'}): ")
      args << value
    end

    args
  end
end

# included input methods in Object
class Object
  include TakeInputs
end

# class derived from String
class MyString < String
  def add_text(text)
    self << text
  end

  def exclude?(text)
    !include?(text)
  end

  def join_with_star
    chars.join('*')
  end

  def repeat(times = 2)
    times = Integer(times) rescue (raise ArgumentError, 'Enter a valid integer')
    self * times
  end

  def surround(prefix, suffix = '!')
    "#{prefix}#{self}#{suffix}"
  end
end

# main
begin
  str = input_string
  obj = MyString.new(str)

  method_name, args = input_complete_method(obj)
  p obj.send(method_name, *args)
rescue ArgumentError, NoMethodError => e
  puts "#{e.class}: #{e.message}"
end