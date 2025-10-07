# frozen_string_literal: true

# custom error class for negative quantity 
class NegativeQuantityError < StandardError
  def initialize(msg = 'Not enough quantity')
    super(msg)
  end
end

# custom error class for non existent items
class NoItemError < StandardError
  def initialize(msg = 'Item does not exist')
    super(msg)
  end
end

# class to store individual item
class Item
  attr_accessor :quantity
  attr_accessor :name

  def initialize(name, quantity)
    @name = name.capitalize
    @quantity = quantity
  end

  def increment(value)
    @quantity += value
  end

  def decrement(value)
    result = quantity - value
    if result.negative?
      puts 'Warning: not enough items'
      @quantity = 0
    else
      @quantity = result
    end
  end

  def update_quantity(value)
    self.quantity = value
  end
end

# shopping list
class ShoppingList
  attr_accessor :list

  def initialize
    @list = []
  end

  def add(name, quantity)
    item = find_item(name)
    if item
      puts "#{item.name} already exists. Updating the quantity."
      item.increment(quantity)
    else
      self.list << Item.new(name, quantity)
    end
  end

  def remove(name, quantity)
    item = find_item(name)
    item ? item.decrement(quantity) : (puts "Item:#{name} does not exist")
  end

  def update(name, quantity)
    item = find_item(name)
    raise NoItemError, "Item '#{name}' does not exist" unless item
    item.update_quantity(quantity)
  end
  
  def delete_item(name)
    item = find_item(name)
    raise NoItemError, "Item '#{name}' does not exist" unless item
    list.delete(item)
  end

  def display
    list.each { |item| puts "#{item.name}: #{item.quantity}" }
  end

  def items(&blk)
    instance_eval(&blk)
  rescue NoItemError, NegativeQuantityError => e
    puts "Error: #{e.message}"
  end

  private

  def find_item(name)
    list.find { |item| name.capitalize == item.name}
  end
end

# usage
s1 = ShoppingList.new

s1.items do
  add('apple', 3)
  add('apple', 2)
  add('guava', 4)
  add('berry', 10)
  remove('banana', 1)
  update('apple', 10)
  delete_item('apple')
end

s1.display