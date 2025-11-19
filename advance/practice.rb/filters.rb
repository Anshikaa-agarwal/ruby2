# frozen_string_literal: true

# module for filter methods
module MyModule
  def self.included(klass)
    klass.extend ClassMethods
  end

  # module to store class methods
  module ClassMethods
    def before_filter(*args, **keyword)
      add_filter(:before, *args, **keyword)
    end

    def after_filter(*args, **keyword)
      add_filter(:after, *args, **keyword)
    end

    def add_filter(type, *methods, **opts)
      @filters ||= Hash.new { |h, k| h[k] = [] }
      methods.each { |m| @filters[type] << [m, opts] }
    end

    def call_filter(type, obj, action_name)
      return unless @filters && @filters[type]

      @filters[type].each do |method, opts|
        next if opts[:only] && !Array(opts[:only]).map(&:to_sym).include?(action_name)
        next if opts[:except] && Array(opts[:except]).map(&:to_sym).include?(action_name)

        execute_filter(obj, method)
      end
    end

    def execute_filter(obj, method)
      method.is_a?(Proc) ? method.call : send_private_method(obj, method)
    end

    def send_private_method(obj, method)
      raise "#{method} must be a private method" unless obj.private_methods.include?(method)
      obj.send(method)
    end

    def aliased(met)
      @aliased ||= []
      @aliased << met
    end

    def action_methods(*args)
      @action ||= []
      @action.concat(args.map(&:to_sym))
      args.each { |met| redefine_method(met) if instance_methods.include?(met) }
    end

    def method_added(name)
      return if @adding_a_method

      @action ||= []
      @aliased ||= []

      return unless @action.include?(name)
      return if @aliased.include?(name)

      wrap_redefine(name)
    end

    def wrap_redefine(name)
      @adding_a_method = true
      redefine_method(name)
      @adding_a_method = false
    end

    def redefine_method(method_name)
      new_method = :"original_#{method_name}"
      return if instance_methods.include?(new_method)

      alias_method new_method, method_name
      aliased(method_name)
      define_method(method_name) do |*vals, &blk|
        self.class.call_with_filter(self, method_name, *vals, &blk)
      end
    end

    def call_with_filter(reciever, name, *vals, &blk)
      call_filter(:before, reciever, name)
      reciever.send(:"original_#{name}", *vals, &blk)
      call_filter(:after, reciever, name)
    end
  end
end

# Example class
class MyClass
  include MyModule

  before_filter :foo, :bar, (proc { puts 'say hi' })
  before_filter :foo, only: [:my_method]
  after_filter :baz
  after_filter :baz, except: [:your_method]

  action_methods :my_method, :your_method

  def my_method
    puts 'my_method'
  end

  def your_method
    puts 'your_method'
  end

  def fake_method
    puts 'fake_method'
  end

  action_methods :fake_method

  private

  def foo
    puts 'foo'
  end

  def bar
    puts 'bar'
  end

  def baz
    puts 'baz'
  end
end

MyClass.new.my_method
MyClass.new.your_method
MyClass.new.fake_method