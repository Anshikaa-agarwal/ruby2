module Validations
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def validates(attr, **options)

    end
  end

  def self.validates(attr, **options)
    @validation_attr ||= []
    @validation_attr << {name: attr, validations: options}
  end

  def errors
    @errors ||= []
  end

  def error_types
    @error_types = {presence: }
  end

  def valid?
    @errors ||= []
    errors.empty?
  end

  def self.validate
    @validation_attr ||= []
    @validation_attr.each do |arr|
      met = "#{arr}="
      original = "original_#{met}"
      alias_method original, met
      define_method(original) do |val|

      end
    end
  end
end

class User
  include Validations

  attr_accessor :name, :email, :age

  validates :name, presence: true
  validates :email, presence: true, format: /@/
  validates :age, numericality: true
end
