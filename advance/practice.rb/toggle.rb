class NoVariableError < StandardError
  def initialize(msg = 'No such instance variable defined')
    super(msg)
  end
end

class FeatureFlags
  class Base
    def self.features
      @features ||= []
    end

    def self.feature(attr, **options)
      features << { name: attr, default: options[:default] || false, context: options[:context] }
      # dark_mode?
      define_method ("#{attr}") do
        val = options[:default] ? options[:default] : false
        instance_variable_set("@#{attr}", val )
      end

      define_method("#{attr}?") do
        var = "@#{attr}"
        if instance_variable_defined?(var)
          instance_variable_get(var)
        else
          raise NoVariableError
        end
      end
      # enable_dark_mode?
      define_method("enable_#{attr}!") do
        var = "@#{attr}"
        instance_variable_defined?(var) ? instance_variable_set(var, true) : (raise NoVariableError)
      end
      # disable_dark_mode?
      define_method("disable_#{attr}!") do
        var = "@#{attr}"
        instance_variable_defined?(var) ? instance_variable_set(var, false) : (raise NoVariableError)
      end
    end

    def initialize
      self.class.features.each do |attr|
        instance_variable_set("@#{attr[:name]}", attr[:default])
      end
    end
  end
end

class AppConfig < FeatureFlags::Base
  feature :dark_mode, default: true
  feature :new_cart,  default: false

  feature :checkout_redesigned, context: :redesigned
  feature :cart_redesigned, context: :redesigned
end

cfg = AppConfig.new
p cfg.dark_mode?
p cfg.new_cart?
cfg.disable_dark_mode!
p cfg.dark_mode?