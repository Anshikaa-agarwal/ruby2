# frozen_string_literal: true

# custom error class for invalid key
class InvalidKey < StandardError
  def initialize(msg = 'Invalid key')
    super(msg)
  end
end

# data type to store individual table
class Table
  def initialize(name)
    @name = name
    @rows = []
    @attributes = []
  end

  def add_row(**keywords)
    row = Row.new(@attributes, **keywords)
    @rows << row
    row
  end

  def add_attr(attr)
    @attributes << attr
  end

  def rows
    @rows
  end

  def attributes
    @attributes
  end
end

# data type to store each row in table
class Row
  def initialize(attributes, **values)
    @data = {}

    attributes.each do |attr|
      @data[attr] = values[attr]

      define_singleton_method(attr) { @data[attr] }
      define_singleton_method("#{attr}=") { |val| @data[attr] = val }
    end
  end

  def [](key)
    @data[key]
  end

  def []=(key, val)
    @data[key] = val
  end

  def update(**keywords)
    keywords.each_pair do |key, val|
      self[key] = val
    end
  end

  def to_h
    @data
  end
end

# parent class
class ApplicationRecord
  def self.inherited(klass)
    @@table ||= {}
    @@table[klass] = Table.new(klass)
  end

  def self.table
    @@table[self]
  end

  def self.attribute(attr)
    table.add_attr(attr)
  end

  def self.create(**keywords)
    @id ||= 0
    @id += 1
    validate_create(**keywords)
    add_to_table(**keywords)
  end

  def self.validate_create(**keywords)
    attr_list = table.attributes
    keys = keywords.keys
    raise InvalidKey unless keys.union(attr_list) == attr_list
  end

  def self.add_to_table(**keywords)
    record = { id: @id }.merge(keywords)
    table.add_row(**record)
    record
  end

  def self.find_by(**keywords)
    table.rows.find do |row|
      keywords.all? { |key, val| row[key] == val }
    end
  end

  def self.delete(**keywords)
    table.rows.delete_if do |row|
      keywords.all? { |key, val| row[key] == val }
    end
  end
end

# child class - User
class User < ApplicationRecord
  attribute :name
  attribute :email
  has_many :orders
end

# child class - Order
class Order < ApplicationRecord
  attribute :number
  attribute :amount
  belongs_to :user
end

begin
  p User.create(name: 'John', email: 'john@example.com')
  p User.create(name: 'abc', email: 'john@example.com')
  p Order.create(number: 'Order 1', amount: 100, user_id: 1)
  o1 = Order.find_by(number: 'Order 1')

  p User.table.rows
  User.delete(name: 'John')
  p User.table.rows
rescue StandardError => e
  p e
end