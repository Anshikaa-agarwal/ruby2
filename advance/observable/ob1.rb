require 'observer'

class Clock
  include Observable

  attr_accessor :time

  def initialize
    @time = Time.now
  end

  def an_hour_later
    @time += 3600
    changed
    notify_observers(@time)
  end

  def a_min_later
    @time += 60

  end
end

class ClockDisplay
  def update(time)
    puts "Time has been updated to: #{time}"
  end
  def update2(time)
    puts "Time has been updated to: #{time}...."
  end
end

clk1 = Clock.new
cd1 = ClockDisplay.new
cd2 = ClockDisplay.new

clk1.add_observer(cd1)

clk1.an_hour_later
clk1.a_min_later