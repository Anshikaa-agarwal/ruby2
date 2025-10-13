module DefaultAttributes
  def self.included(klass)
    klass.extend ClassMethods
  end

  def initialize(**keywords)
    keywords.each_pair do |attr, val|
      instance_variable_set("@#{attr}", val)
    end
  end

  module ClassMethods
    def set_defaults(**defaults)
      defaults.each_pair do |attr, value|
        define_method(attr) do 
          val = instance_variable_get("@#{attr}")
          val ? val : value
        end
      end 
    end
  end
end

class Product
  include DefaultAttributes

  attr_accessor :name, :price, :category
  set_defaults name: "Unknown", price: 0.0
end

p1 = Product.new
p p1.name      #=> "Unknown"
p p1.price     #=> 0.0
p p1.category  #=> nil

p2 = Product.new(name: "Laptop", category: "Electronics")
p p2.name      #=> "Laptop"
p p2.price     #=> 0.0
p p2.category  #=> "Electronics"