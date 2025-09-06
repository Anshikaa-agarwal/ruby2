class Item
    attr_accessor :name, :imported, :exempted, :price

    def initialize(name, imported, exempted, price)
        @name = name
        @imported = imported
        @exempted = exempted
        @price = price
    end

    def tax_amt
        tax = 0
        tax += price * 0.1 unless exempted
        tax += price * 0.05 if imported
        tax
    end
    
    def final_price
        price + tax_amt
    end
end

class List
    def initialize
        @items = []
        @total_cost = 0
    end

    def add_item(item)
        @items << item
        @total_cost += item.final_price
    end

    def display
        @items.each_with_index do |item, index|
            puts "Item #{index+1}:"
            puts "Name: #{item.name}"
            puts "Price before tax: #{item.price}"
            puts "Price after tax: #{item.final_price}"
        end
        puts "Total cost: #{@total_cost}"
    end
end

list = List.new

loop do
    print "Name of the product: "
    name = gets.chomp

    print "Imported?: "
    imported = gets.chomp.match?(/yes/i) ? true : false

    print "Exempted from sales tax? "
    exempted = gets.chomp.match?(/yes/i) ? true : false

    print "Price: "
    price = gets.chomp.to_f

    list.add_item(Item.new(name, imported, exempted, price))

    print "Do you want to add more items to your list(y/n): "
    more = gets.chomp.match?(/^y$/i) ? true : false

    break unless more
end

list.display