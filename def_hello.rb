class A
  METHODS = {hello: "p 'hello'", greet: "puts \"good evening \#\{args\}\"", time_now: "Time.now"}

  class << self

    def a=(val)
      @a = val
      toggle_methods
    end

    def instance_variable_set(name, val)
      result = super(name, val)
      toggle_methods if name == :@a
      result
    end

    def toggle_methods
      send(@a ? :create_methods : :remove_if_exist)
    end

    def create_methods
      METHODS.each_pair { |name, code| define_method(name) { |*args| instance_eval(code) } }
    end

    def remove_if_exist
      METHODS.each_key { |name| undef_method(name) if instance_methods.include?name.to_sym }
    end

  end
end

# A.new.greet

def met1(name, age)
  "#{name} is #{age} years old"
end


A.a = 10
A.new.hello
A.new.greet('abc', 'def')

A.instance_variable_set(:@a, 20)
A.new.hello

A.instance_variable_set(:@a, nil)
A.new.hello