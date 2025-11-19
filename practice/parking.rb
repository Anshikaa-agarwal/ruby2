class Vehicle
  @@count = 0

  attr_accessor :parked

  def initialize(plate)
    @plate = plate
    @parked = false
    @@count += 1
  end

end

class Car < Vehicle
  @active_count = 0

  def initialize(plate)
    super
    @size = size
  end

end

class Motorcycle < Vehicle
  def initialize(plate, size)
    super(plate)
    @size = size
  end
end

class Truck < Vehicle
end

class Spot
  def initialize(small:, medium:, large:)
    @small = small
    @medium = medium
    @large = large
  end

  def park(vehicle_instance)
    
end

class CompactSpot < Spot
end

class LargeSpot < Spot
end
