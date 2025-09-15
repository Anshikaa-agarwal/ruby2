class Greeter
  def hello(name) = "Hello, #{name}!"
  def goodbye(name) = "Goodbye, #{name}!"
  def welcome(name) = "Welcome, #{name}!"
end

def input(str)
  print str
  gets.chomp
end

greeter1 = Greeter.new
greetings = Greeter.public_instance_methods(false)

greeting = input("Enter greeting (#{greetings.join(', ')}): ").strip.downcase

begin
  raise NoMethodError, 'No such method' unless greeter1.respond_to?(greeting)
  name = input('Enter name: ').strip.capitalize
  puts greeter1.send(greeting, name)

  rescue => e
    puts e.message
end
