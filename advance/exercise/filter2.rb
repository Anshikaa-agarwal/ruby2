# frozen_string_literal: true

# module to store filter methods
module Filter
  def filters
    @filters ||= { before: [], after: [], actions: [] }
  end

  def before_filter(*args, **keyword)
    
  end

  def after_filter(*args)
    filters[:after].concat(args)
  end

  def action_methods(*args, **keyword)
    filters[:actions].concat(args)


  end

  # if action_method is called on a method, redefine it, else return
  def method_added(method_name)
    return unless filters[:actions].include?(method_name)
    return if @adding_a_method

    @adding_a_method = true
    redefine_method(method_name)
    @adding_a_method = false
  end

  # redefine method by before, send, after
  def redefine_method(met)
    new_method = :"original_#{met}"
    alias_method new_method, met

    define_method(met) do |*vals, &blk|
      self.class.call_methods(self, new_method, *vals, &blk)
    end
  end

  # code to run before and after filters
  def call_methods(obj, met, *vals, &blk)
    call_filter_methods(obj, :before)
    obj.send(met, *vals, &blk)
    call_filter_methods(obj, :after)
  end

  # if obj is a proc, call it, otherwise send the method
  def call_filter_methods(obj, type)
    filters[type].each do |met|
      if met.is_a?(Proc)
        met.call
      else
        raise "#{met} must be a private method" unless obj.private_methods.include?(met)
        obj.send(met)
      end
    end
  end
end

# Sample test class
class MyClass
  extend Filter

  before_filter :foo, :bar, proc { puts 'hey' }
  after_filter :baz
  action_methods :my_method, :your_method

  def my_method
    puts 'I am my_method'
  end

  def your_method
    puts 'I am your_method'
  end

  

  def fake_method
    puts 'I am fake_method'
  end

  private

  def foo
    puts 'I am foo'
  end

  def bar
    puts 'I am bar'
  end

  def baz
    puts 'I am baz'
  end
end

MyClass.new.my_method
