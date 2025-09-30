# frozen_string_literal: true

# out of bound quantity
class NegativeQuantity < StandardError; end

# class Item with name
class Item
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end

  def ==(other)
    other.is_a?(Item) && name.downcase == other.name.downcase
  end

  def eql?(other)
    self == other
  end

  def hash
    name.downcase.hash
  end
end

# class shopping list with methods to access it
class ShoppingList
  attr_accessor :list

  def initialize
    @list = Hash.new(0)
  end

  def add(item, quantity)
    item = make_item(item)
    list[item] += quantity
  end

  def remove(item, quantity)
    item = make_item(item)
    if (list[item] - quantity).negative?
      list[item] = 0
      raise NegativeQuantity, "Warning: Not enough #{item.name}s"
    else
      list[item] -= quantity
    end
  end

  def items(&blk)
    instance_eval(&blk)
  end

  def to_s
    @list.map { |item, quantity| "#{item.name}: #{quantity}" }.join("\n")
  end

  private

  def make_item(obj)
    obj.is_a?(Item) ? obj : Item.new(obj.to_s.capitalize)
  end
end

# usage
s1 = ShoppingList.new

begin
  s1.items do
    add('toothpaste', 2) 
    add('Computer', 1) 
    add('tOothpaste', 2) 
    remove('Book', 2)
  end
rescue NegativeQuantity => e
  puts e.message
end

puts s1
