module FilteredTracker
  def self.included(klass)
    klass.extend ClassMethods
  end

  def tracked_calls
    @tracked_calls ||= Hash.new { |h, k| h[k] = [] }
  end

  module ClassMethods
    def track_methods(*methods, filter: nil)
      @track_list ||= {}

      methods.each do |met|
        methods.each { |m| @track_list[m] = filter }
        redefine(met, filter) if instance_methods.include?(met)
      end
    end

    def method_added(name)
      return unless @track_list&.key?(name)
      return if @wrapping

      @wrapping = true
      redefine_method(name, @track_list[name])
      @wrapping = false
    end

    def redefine_method(name, filter)
      original = "original_#{name}"
      alias_method original, name

      define_method name do |*args, &blk|
        result = send(original, *args, &blk)
        if filter.nil? || filter.call(args, result)
          @tracked_calls[name] << (filter ? args + [result] : args)
        end
        result
      end
    end
  end
end

class Calculator
  include FilteredTracker

  track_methods :add, :multiply, filter: ->(args, result) { result > 10 }

  def add(a, b)
    a + b
  end

  def multiply(a, b)
    a * b
  end
end

c = Calculator.new
p c.add(2, 3)       # ignored, result = 5 < 10
p c.multiply(3, 5)  # stored, result = 15 > 10
p c.tracked_calls    #=> {:multiply=>[[3, 5, 15]]}
