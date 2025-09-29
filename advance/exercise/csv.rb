# frozen_string_literal: true

require 'csv'

# Module for CSV helper methods
module CSVParser
  def read_csv(path)
    CSV.read(path, headers: true)
  end

  def file_name_get(path)
    File.basename(path, '.csv')
  end

  def get_headers(path)
    read_csv(path).headers
  end
end

# Class to dynamically creat classes
class DynamicCSV
  include CSVParser
  attr_reader :path, :data, :klass, :obj_list

  def initialize(path)
    @path = path
    @data = read_csv(path)
    @klass = Object.const_set(class_name_get, Class.new)
    add_instance_variables
    create_objects
  end

  def class_name_get
    file_name_get(path).capitalize
  end

  def method_names_get
    get_headers(path).map(&:downcase)
  end

  def add_instance_variables
    method_names_get.each do |method_name|
      klass.class_eval do
        define_method(method_name) do
          instance_variable_get("@#{method_name}")
        end
        define_method("#{method_name}=") do |val|
          instance_variable_set("@#{method_name}", val)
        end
      end
    end
  end

  def create_objects
    @obj_list = []
    headers = get_headers(path)
    method_names = method_names_get

    data.each do |row|
      obj = klass.new
      headers.each_with_index do |header, i|
        obj.send("#{method_names[i]}=", row[header])
      end
      @obj_list << obj
    end
  end
end

path = 'C:\Users\anshi\Desktop\ruby\csv\e1.csv'

d1 = DynamicCSV.new(path)
d1.obj_list.each do |obj|
  puts "Name: #{obj.name}"
  puts "Email: #{obj.email}"
  puts "Age: #{obj.age}"
  puts "City: #{obj.city}"
end