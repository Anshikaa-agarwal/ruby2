# frozen_string_literal: true

# module to store filters
module Filter
  def before_filter(*args)
    @before_filters ||= []
    @before_filters.concat(args)
  end

  def after_filter(*args)
    @after_filters ||= []
    @after_filters.concat(args)
  end

  def action_methods(*args)
    @action_method ||= []
    @action_method.concat(args)
  end

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

  def call_methods(obj, new_method, *vals, &blk)
    call_filter_methods(obj, before_filter)
    obj.send(new_method, *vals, &blk)
    call_filter_methods(obj, after_filter)
  end

  def redefine_method(method_name)
    new_method = :"original_#{method_name}"
    alias_method new_method, method_name

    define_method(method_name) do |*vals, &blk|
      self.class.call_methods(self, new_method, *vals, &blk)
    end
  end

  def method_added(method_name)
    # if method is not included in action_methods, return
    return unless @action_method.include?(method_name)

    # if included, redefine the method whenever it is added
    return if @adding_a_method

    @adding_a_method = true
    redefine_method(method_name)
    @adding_a_method = false
  end
end

# sample test class
class MyClass
  extend Filter

  before_filter :foo, :bar
  after_filter :baz
  action_methods :my_method, :your_method

  def my_method
    puts 'i am my_method'
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