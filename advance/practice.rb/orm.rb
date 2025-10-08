class NoDynamicMethodError < StandardError
  def initialize(msg = 'No such dynamic method exists')
    super(msg)
  end
end

class MetaORM
  def self.define_model(name, &blk)
    klass = Object.const_set(name.capitalize, Class.new)

    klass.class_eval do

      @attributes = []
      @computed_methods = []
      @events = []
      @before = []
      @after = []
      @users = []
  
      class << self
        attr_accessor :attributes, :computed_methods, :before, :after
        attr_reader :users
      end

      def self.new
        result = super
        @users << result
        result
      end

      def self.attribute(*args)
        self.attributes.push(*args)
        attr_accessor *args
      end

      def self.computed(name, str)
        @computed_methods << name
        define_method(name) do
          instance_eval(str)
        end
      end

      def self.event(name)
        @events << name
      end

      def self.before_save(*args)
        @before.push(*args)
      end

      def self.after_save(*args)
        @after.push(*args)
      end

      def save
        self.class.before.each { |met| send(met) } 
        self.class.after.each { |met| send(met) }
      end

      def self.all
        @users
      end

      def self.method_missing(name, *args, &blk)
        if name.start_with?('find_by_')
          base = name.match(/^find_by_(.*)$/)[1]
          unless @attributes.include?(base.to_sym)
            raise NoDynamicMethodError, "No such attribute '#{base}'"
          end

          result = @users.find { |user| user.send(base) == args[0] }
          raise NoDynamicMethodError, "No record found for #{base}: #{args[0]}" unless result
          result
        else
          super
        end
      end

      def self.respond_to_missing?(name, include_private = false)
        name.to_s.start_with?('find_by_') || super
      end
    end

    klass.class_eval(&blk)
    klass
  end
end

User = MetaORM.define_model("User") do
  attribute :name, :email, :age
  computed :greeting, '"Hello, #{name}! You are #{age} years old."'

  event :before_save
  event :after_save

  before_save :normalize_name
  after_save  :announce_save

  def normalize_name
    self.name = name.strip.capitalize if name
  end

  def announce_save
    puts "User #{name} has been saved!"
  end
end

u1 = User.new
u1.name = "  alice "
u1.email = "alice@example.com"
u1.age = 22
u1.save

u2 = User.new
u2.name = "bob"
u2.email = "bob@example.com"
u2.age = 25
u2.save

p User.all.map(&:name)
p User.find_by_name("Alice")