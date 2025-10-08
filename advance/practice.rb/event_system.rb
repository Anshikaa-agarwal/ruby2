class NoSuchEventError < StandardError; end

class Event
  attr_reader :name
  attr_accessor :callbacks

  def initialize(name)
    @name = name
    @callbacks = []
  end
end

class EventSystem
  @event_list = []

  class << self
    attr_accessor :event_list
  end

  def self.define_event(name)
    self.event_list << Event.new(name)
  end

  def self.on(event_name, &blk)
    event = find_event(event_name)
    event.callbacks << blk
  end

  def self.trigger(event_name, *args)
    event = find_event(event_name)
  end

  def self.list_events
    event_list.each { |event| puts event.name }
  end

  private

  def self.find_event(name)
    event = event_list.find { |event| event.name == name }
    raise NoSuchEventError, "Event '#{name}' does not exist" unless event
    event
  end
end

EventSystem.define_event("UserLoggedIn")
EventSystem.define_event("DataUpdated")

EventSystem.on("UserLoggedIn") do |user|
  puts "Welcome, #{user}!"
end

EventSystem.on("UserLoggedIn") do |user|
  puts "Sending login notification for #{user}"
end

EventSystem.trigger("UserLoggedIn", "Alice")
EventSystem.list_events