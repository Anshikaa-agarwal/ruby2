module Trackable
  def self.included(klass)
    klass.extend ClassMethods
  end

  def tracked_calls
    @track_record
  end

  def track_record
    @track_record ||= Hash.new{ |h,k| h[k] = [] }
  end

  module ClassMethods

    def track_methods(*args)
      @track ||= []
      @track.concat(args)

      args.each do |met|
        redefine_method(met) if instance_methods.include?(met)
      end
    end

    def method_added(name, *args, &blk)
      @track ||= []
      return unless @track.include?(name)
      return if @adding_method

      @adding_method = true
      redefine_method(name)
      @adding_method = false
    end

    def redefine_method(met)
      original = "original_#{met}"
      alias_method original, met
      define_method(met) do |*vals|
        result = send(original, *vals)
        track_record[met] << vals
        result
      end
    end

  end
end

class Calculator
  include Trackable

  track_methods :add, :multiply

  def add(a, b)
    a + b
  end

  def multiply(a, b)
    a * b
  end

  def subtract(a, b)
    a - b
  end

  
end

c = Calculator.new

p c.add(2, 3)       #=> 5
p c.multiply(4, 5)  #=> 20
p c.subtract(10, 3) #=> 7

p c.tracked_calls
