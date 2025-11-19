# frozen_string_literal: true

require 'csv'

# Custom error if file does not exist
class NoFileError < StandardError
  def initialize(msg = 'File does not exist')
    super(msg)
  end
end

# Module for CSV utilities
module CSVParser
  def self.read_csv(path)
    raise NoFileError unless File.exist?(path)

    CSV.read(path, headers: true)
  end

  def self.class_name_from_file(path)
    File.basename(path, '.csv').capitalize
  end
end

# Dynamic class from CSV file
class DynamicCSV
  attr_reader :path, :klass, :objects

  def initialize(path)
    @path = path
    @data = CSVParser.read_csv(path)
    @objects = []
  end

  def parse
    create_class
    create_objects
  end

  def print_csv
    @objects.each do |obj|
      @data.headers.each do |header|
        puts "#{header.capitalize}: #{obj.send(header.downcase)}"
      end
      puts '-' * 20
    end
  end

  private

  def create_class
    @klass = Object.const_set(CSVParser.class_name_from_file(path), Class.new)
    @data.headers.each do |header|
      @klass.class_eval do
        attr_accessor header.downcase
      end
    end
  end

  def create_objects
    @objects = @data.map { |row| create_an_obj(row) }
  end
  
  def create_an_obj(row)
    obj = klass.new
      row.to_h.each do |header, value|
        value = value.to_i if value =~ /^\d+$/
        obj.send("#{header.downcase}=", value)
      end
    obj
  end
end

path = 'C:\Users\anshi\Desktop\ruby\csv\e1.csv'
csv_obj = DynamicCSV.new(path)
csv_obj.parse
csv_obj.print_csv