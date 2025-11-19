# frozen_string_literal: true

# module to define dirty objects
module DirtyObject
  def self.included(klass)
    klass.extend ClassMethods
  end

  def dirty_attributes
    self.class.instance_variable_get(:@dirty_attr)
  end

  def changed?
    @changes = {}
    @check = false
    dirty_attributes.each do |attr|
      add_to_changed(attr) if send(attr) != send("#{attr}_was")
    end
    @check
  end

  def add_to_changed(attr)
    @changes[attr] = [send("#{attr}_was"), send(attr)]
    @check = true
  end

  def changes
    changed?
    @changes
  end

  # module to store class methods
  module ClassMethods
    def define_dirty_attributes(*args)
      @dirty_attr ||= []
      @dirty_attr.concat(args)
      args.each { |met| define_dirty_methods(met) }
    end

    private

    def define_dirty_methods(met)
      def_was_getter(met)
      def_was_setter(met)
      redefine_attribute_setter(met)
    end

    def def_was_getter(met)
      var = "#{met}_was"
      define_method(var) do
        val = instance_variable_get("@#{var}")
        val || send("#{var}=", send(met))
      end
    end

    def def_was_setter(met)
      var = "#{met}_was"
      define_method("#{var}=") do |val|
        instance_variable_set("@#{var}", val)
      end
    end

    def redefine_attribute_setter(met)
      define_method("#{met}=") do |val|
        curr_val = instance_variable_get("@#{met}")
        send("#{met}_was=", curr_val) if curr_val != val
        instance_variable_set("@#{met}", val)
      end
    end
  end
end

# User class
class User
  include DirtyObject

  attr_accessor :name, :age, :email
  define_dirty_attributes :name, :age
end

u = User.new

u.name  = 'Akhil'
u.email = 'akhil@vinsol.com'
u.age   = [1,2,3]

# p u.changed?
# p u.changes

u.name = 'abc'
u.age << 4
p u.name_was
p u.age_was

p u.changed?
p u.changes