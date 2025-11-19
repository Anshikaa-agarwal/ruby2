class Settings

  def initialize(names)
    @setting_list = names
    self.class.set_attr_accessor(names)
  end

  def self.set_attr_accessor(arr)
    arr.each do |element|
      define_method(element) do
        instance_variable_get("@#{element}")
      end
      define_method("#{element}=") do |val|
        instance_variable_set("@#{element}", val)
      end
    end
  end
end

if ARGV.empty?
  puts 'Please provide an input'
else
  input = ARGV[0].gsub(/[\[\]\:]/, '').split(',').map { |str| str.strip.to_sym }
  s1 = Settings.new(input)
  puts s1.theme
  s1.theme = "new"
  puts s1.theme
end