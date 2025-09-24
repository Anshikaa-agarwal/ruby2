# frozen_string_literal: true

# out of bound quantity
class NegativeQuantity < StandardError; end

# class shopping list with methods to access it
class ShoppingList
  attr_accessor :list

  def initialize
    @list = Hash.new(0)
  end

  def add(item, quantity)
    list[item] += quantity
  end

  def remove(item, quantity)
    if (list[item] - quantity).negative?
      list[item] = 0
      raise NegativeQuantity, "Warning: Not enough #{item}s"
    else
      list[item] -= quantity
    end
  end

  def items(&blk)
    instance_eval(&blk)
  end

  def to_s
    @list.map { |item, quantity| "#{item}: #{quantity}" }.join("\n")
  end
end

s1 = ShoppingList.new
begin
  s1.items do
    remove('Book', 2)
    add('Toothpaste', 2)
    add('Computer', 1)
  end
rescue
  puts ($!).message
end

puts s1