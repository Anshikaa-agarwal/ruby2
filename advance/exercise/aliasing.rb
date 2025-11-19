# frozen_string_literal: true

# module to set name
module NameHelper
  METHOD_NAME = /(?<base>.*?)(?<punct>[!?=])?$/.freeze
  def self.method_names_set(name, suffix)
    matched = name.match(METHOD_NAME)
    ["#{matched[:base]}_without_#{suffix}#{matched[:punct]}", "#{matched[:base]}_with_#{suffix}#{matched[:punct]}"]
  end
end

# module for chained aliasing
module MyModule
  def self.included(base)
    base.extend ClassMethods
  end

  # module to include class methods
  module ClassMethods
    extend NameHelper

    def chained_aliasing(name, suffix)
      without, with = NameHelper.method_names_set(name, suffix)

      alias_method without, name
      define_method(name) { |*args, &blk| public_send(with, *args, &blk) }
      set_visibility(name, with)
    end

    def set_visibility(name, *args)
      visibility = check_visibility(name)
      args.each do |met|
        send(visibility, met)
      end
    end

    def check_visibility(name)
      return :private if private_method_defined?(name)

      return :protected if protected_method_defined?(name)

      :public
    end
  end
end

# Example usage
class Hello
  include MyModule

  def greet
    puts 'hello'
  end

  def greet_with_logger
    puts '--logging start'
    greet_without_logger
    puts '--logging end'
  end

  chained_aliasing :greet, :logger
end

say = Hello.new
say.greet