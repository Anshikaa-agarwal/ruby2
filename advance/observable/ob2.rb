require 'observable'

class Stock
  include Observable
  attr_accessor :price
  def initialize(company, price)
    @company = company
    @price = price
  end

  def rise(delta)
    old = price
    self.price *= (1 + delta)
    notify_price_change(old, new_price, delta)
  end

  def fall(delta)
    self.price *= (1 - price)
    notify_price_change(old, new_price, delta)
  end

  def notify_price_change(old, new_price, delta)
    changed
    notify_observers(old, new_price, delta)
  end
end

class Analyst
  def initialize(name)
    @name = name
  end

  def update(old, new_price, delta)
    puts ''
