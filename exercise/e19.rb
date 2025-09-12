# frozen_string_literal: true

require 'time'

# validates the string format
class String
  TIME_REGEX = /^(?<hours>[01]?\d|2[0-3]):(?<minutes>[0-5]?\d):(?<seconds>[0-5]?\d)$/.freeze

  def valid_time_format
    match(TIME_REGEX)
  end

  def to_seconds
    obj = self.valid_time_format
    obj ? obj[:hours].to_i * 3600 + obj[:minutes].to_i * 60 + obj[:seconds].to_i : return nil
  end
end

class Integer
  def to_time
    days, remainder = divmod(24 * 3600)
    hours, remainder = remainder.divmod(3600)
    minutes, seconds = remainder.divmod(60)

    Time.local(0, 1, 1, hours, minutes, seconds)
  end
end

# Sum of seconds
class Time
  def to_string
    formatted = strftime("%H:%M:%S")
    day > 1 ? "#{day-1} day#{'s' if day > 2} & #{formatted}" : formatted
  end
end

# Sum durations
class Array
  def sum_durations
    total_seconds = map(&:to_seconds).compact
    return nil if total_seconds.size != size

    total_seconds.sum
  end
end

if ARGV.empty?
  puts 'Please provide an input'
else
  total = ARGV.sum_durations
  if total.nil?
    p 'Invalid 24-hour time value'
  else
    p total.to_time.to_string
  end
end