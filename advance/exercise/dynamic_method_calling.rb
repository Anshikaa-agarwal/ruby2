# methods to take input
module TakeInputs
  def input(msg)
    print msg
    gets.chomp
  end

  def input_string
    input('Enter string: ')
  end

  def display_defined_methods(class_name)
    print 'List of methods defined: '
    p class_name.instance_methods(false)
  end

  def choose_method
    input('Choose a method: ')
  end

  def input_complete_method(obj)
    display_defined_methods(obj.class)
    method_name = choose_method
    args = []
    method_to_call = obj.method(method_name)
    args = input_args if method_to_call.arity != 0
    [method_name, args]
  end

  def input_args
    input('Enter arguments: ').split
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
    !include?text
  end

  def join_with_star
    chars.join('*')
  end

  def repeat(times = 2)
    times = Integer(times) rescue (raise ArgumentError, 'Enter a valid integer')
    self * times.to_i
  end

  def surround(prefix, suffix = "!")
    "#{prefix}#{self}#{suffix}"
  end
end

str = input_string
obj = MyString.new(str)

method_name, args = input_complete_method(obj)

begin
  p obj.send(method_name, *args)
rescue ArgumentError, NoMethodError => e
  puts "#{e.class}: #{e.message}"
end

