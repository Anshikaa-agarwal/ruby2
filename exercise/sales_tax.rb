# frozen_string_literal: true

# implementing DRY principle to take input
def input(msg)
  print msg
  gets.chomp
end

# class Item to store individual items and calculate taxes
class Item
  attr_accessor :name, :imported, :exempted, :price

  def initialize(name, imported, exempted, price)
    @name = name
    @imported = imported.match?(/yes/i)
    @exempted = exempted.match?(/yes/i)
    @price = price.to_f
  end

  private

  def tax_amt
    tax = 0
    tax += price * 0.1 unless exempted
    tax += price * 0.05 if imported
    tax
  end

  public

  def final_price
    @price + tax_amt
  end

  def to_s
    "Name: #{name}\n" \
    "Price before tax: #{price}\n" \
    "Price after tax: #{final_price}"
  end
end

# class to store list of items
class List
  def initialize
    @items = []
  end

  def add_item(item)
    @items << item
  end

  def total_cost
    @items.inject(0) { |sum, item| sum + item.final_price }
  end

  def display
    loop do
      option = input("a. Print entire list\nb. Print particular item\nc. Exit\nOption: ")
      case option

      # print entire list
      when 'a'
        @items.each_with_index do |element, index|
          puts "Item #{index + 1}"
          puts element
        end
        puts "Total cost: #{total_cost}"

      # print specific item
      when 'b'

        # maximum 3 invalid options
        try_count = 0
        while try_count < 3
          try_count += 1
          item_id = input('Enter item index: ').to_i
          item = @items[item_id - 1]

          # print item if found
          if item
            puts item
            break

          # retry till 3 attempts
          else
            puts 'Invalid index, try again'
          end
          puts 'Limit reached: 3 tries' if try_count == 3
        end

      # exit
      when 'c'
        break

      # default
      else
        puts 'Invalid option'
      end
    end
  end
end

list = List.new
more = true
while more
  name = input('Name of the product: ')
  imported = input('Imported?: ')
  exempted = input('Exempted from sales tax? ')
  price = input('Price: ')

  list.add_item(Item.new(name, imported, exempted, price))

  more = input('Do you want to add more items to your list(y/n): ').match?(/^y$/i)
end
list.display