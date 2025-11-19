
class User
  def self.create_objects(num, &blk)
    @list = []
    num.times do |i|
      @list << self.new
    end

    @list.each do |obj|
      obj.instance_eval(&blk)
    end

    @list
  end

  def string(*attr)
    attr.each do |val|
      instance_variable_set("@#{val}", "abc")

      define_singleton_method(val) do
        instance_variable_get("@#{val}")
      end

      define_singleton_method("#{val}=") do |value|
        raise ArgumentError unless value.class == String
        instance_variable_set("@#{val}", value)
      end
    end
  end

  def integer(*attr, max: 0)
    attr.each do |val|
      instance_variable_set("@#{val}", rand(1..max))

      define_singleton_method(val) do
        instance_variable_get("@#{val}")
      end

      define_singleton_method("#{val}=") do |value|
        raise ArgumentError if value > max
        instance_variable_set("@#{val}", value)
      end
    end
  end

  def random(*attr, choices: [])
    raise ArgumentError, "Empty array of choices" if choices.empty?
    attr.each do |val|
      instance_variable_set("@#{val}", choices[rand(0...choices.size)])

      define_singleton_method(val) do
        instance_variable_get("@#{val}")
      end

      define_singleton_method("#{val}=") do |value|
        raise ArgumentError unless choices.include?(value)
        instance_variable_set("@#{val}", value)
      end
    end
  end
end


@users = User.create_objects(10) do |t|
  t.string :name, :email # random name, random email
  t.integer :age, max: 40 
  t.random :gender, choices: [:m, :f]
end

u = @users.first(10)
u.each { |user| p user }
