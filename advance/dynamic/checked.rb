module CheckedAttributes
  def attr_checked(name, &blk)

    define_method(name) do
      instance_variable_get("@#{name}")
    end

    define_method "#{name}=" do |val|
      if(blk.call(val))
        instance_variable_set("@#{name}", val)
      else
        raise RuntimeError
      end
    end
  end
end


class Person
  extend CheckedAttributes

  attr_checked :age do |v|
    v >= 18
  end


p1 = Person.new
p1.age = 20
puts p1.age

p1.age = 10