class DataSource
  def initialize
    @info = {
      mouse:     ["Wireless Mouse", 50],
      cpu:       ["Intel i7", 300],
      keyboard:  ["Mechanical Keyboard", 120],
      monitor:   ["27-inch 4K Display", 450]
    }
  end

  def get_mouse_info(id)     = @info[:mouse][0]
  def get_mouse_price(id)    = @info[:mouse][1]

  def get_cpu_info(id)       = @info[:cpu][0]
  def get_cpu_price(id)      = @info[:cpu][1]

  def get_keyboard_info(id)  = @info[:keyboard][0]
  def get_keyboard_price(id) = @info[:keyboard][1]

  def get_monitor_info(id)   = @info[:monitor][0]
  def get_monitor_price(id)  = @info[:monitor][1]
end

class Computer
  def initialize(id, data_source)
    @id = id
    @data_source = data_source
    @components, @attributes = @data_source.methods.grep(/^get_(.*)_(.*)$/) { [$1, $2] }.transpose
  end

  def component(name)
    info = @data_source.send("get_#{name}_info", @id)
    price = @data_source.send("get_#{name}_price", @id)

    result = "Mouse: #{info} ($#{price})"

    return "* #{result}" if price >= 100
    result
  end

  @components.each do |comp|
    define_method :comp do
  end
end

data_source = DataSource.new
comp1 = Computer.new(1, data_source)
puts comp1.mouse