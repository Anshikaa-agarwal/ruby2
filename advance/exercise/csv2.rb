# frozen_string_literal: true

require 'csv'

# Dynamic class to create dynamic names
class DynamicClass
  def initialize(name)
    @my_class = Object.const_set(name, Class.new)
  end

  attr_reader :my_class

  def create_initialize(methods)
    my_class.define_method :initialize do |arr|
      methods.each_with_index { |met, index| method("#{met}=").call(arr[index]) }
    end
  end

  def create_to_s(methods)
    my_class.define_method :to_s do
      puts 'Object :-'
      methods.each { |met| puts "#{met}:- #{method(met).call}" }
    end
  end

  def create_methods(methods)
    my_class.attr_accessor(*methods)
    create_initialize(methods)
    create_to_s(methods)
  end

  def read_csv(objects, file_name)
    CSV.open(file_name) do |csv|
      methods = csv.shift
      create_methods(methods)
      csv.each { |row| objects << my_class.new(row) }
    end
  end

  def read(file_name)
    objects = []
    read_csv(objects, file_name)
    objects.each { |obj| puts obj }
  end
end

puts 'Enter the csv File to open'
file_name = gets.chomp
DynamicClass.new(file_name.match(/[a-z]+/i)[0].capitalize).read(file_name)