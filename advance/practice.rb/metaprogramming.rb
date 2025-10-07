class NoDynamicMethodError < StandardError
  def initialize(msg = 'No such dynamic method exists')
    super(msg)
  end
end

class EntityBuilder
  def self.define(name, &blk)
    klass = Object.const_set(name.capitalize, Class.new)
    klass.class_eval do

      @attributes = []
      @computed_methods = []

      class << self
        attr_reader :attributes, :computed_methods
      end

      # macro: define attributes
      def self.attribute(attr_name)
        @attributes << attr_name
        attr_accessor attr_name
      end

      # macro: define computed methods
      def self.computed(name, code)
        @computed_methods << name
        define_method(name) do
          instance_eval(code)
        end
      end

      # method missing
      def method_missing(name, *args, &blk)
        method_name = name.to_s

        if name[-1] == '='
          var_name = method_name.chop
          self.class.send(:attr_accessor, var_name)
          send(name, args.first) # call the setter
        elsif name.start_with?('get_')
          var_name = method_name.sub(/^get_/, '')
          if instance_variable_defined?("@#{var_name}")
            instance_variable_get("@#{var_name}")
          else
            raise NoDynamicMethodError, "No such dynamic variable: #{var_name}"
          end
        else
          super
        end
      end

      def meta_info
        puts "Attributes: #{attributes}"
        puts "Computed: #{computed}"
      end

    end

    klass.class_eval(&blk) if blk
    klass
  end
end

EntityBuilder.define('product') do
  attribute :name
  attribute :brand

  computed :details, '"#{brand} running #{speed} km/h"'
end

obj = Product.new
obj.name = 'Car'
obj.brand = 'Toyota'
obj.speed = 200
p obj.get_speed
obj.meta_info
p obj.details