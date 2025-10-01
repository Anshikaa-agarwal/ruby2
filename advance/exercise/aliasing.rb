# frozen_string_literal: true

module MyModule
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    define_method :chained_aliasing do |name, logger_method|
      new_method = "#{name}_without_logger"
      alias_method new_method, name

      visibility = check_visiblity(name)

      define_method(name) do |*args, &blk|
        send("#{name}_with_logger", *args, &blk)
      end

      send(visibility, name)
      send(visibility, new_method)
    end

    def check_visiblity(name)
      if private_method_defined?(name)
        :private
      elsif protected_method_defined?(name)
        :protected
      else
        :public
      end
    end
  end
end

class Hello
  include MyModule

  private def greet
    puts 'hello'
  end

  private def greet_with_logger
    puts '--logging start'
    greet_without_logger
    puts '--logging end'
  end

  chained_aliasing :greet, :logger
end

say = Hello.new
say.greet
