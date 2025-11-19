# each table must be array of hashes.

class ApplicationRecord
  def self.inherited(klass)
    @@tables ||= {}
    @@tables[klass] = []
  end

  def self.attribute(attr)
    @attributes ||= []
    @attributes << attr
  end

  def self.create(**keywords)
    # raise ArgumentError unless keywords.keys.sort == @attributes.sort
    @id ||= 0
    @id += 1

    keywords[:id] = @id
    @@tables[self] << keywords
  end

  def self.table
    @@tables[self]
  end

  def self.find_by(**keywords)
    table.select do |entry|
      keywords.all? { |key, value| entry[key] == value }
    end
  end
end

class Users < ApplicationRecord
  attribute :name
  attribute :email
end

class Order < ApplicationRecord
  attribute :number
  attribute :amount
  # belongs_to :user
end

Users.create(name: "John", email: "john@example.com")
Users.create(name: "abc", email: "abc@example.com")
Order.create(number: "Order 1", amount: 100, user_id: 1)
o1 = Order.find_by(number: "Order 1")
p o1
p o1.name