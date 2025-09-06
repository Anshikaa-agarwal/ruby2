# frozen_string_literal: true

# class array to inject in hash
class Array
  def hash_inject
    hashh = Hash.new([])
    inject(hashh) do |memo, element|
      len = element.size
      type = len.odd? ? 'odd' : 'even'

      sub_array = memo[type].find { |arr| arr.first.size == len }
      sub_array ? sub_array += [element] : memo[type] += [[element]]
      memo
    end
  end
end

# monkeypatching String for input conversion
class String
  BRACKET_QUOTE = /[\[\]']/.freeze
  def to_array
    gsub(BRACKET_QUOTE, '').split(',')
  end
end

if ARGV.empty?
  puts 'Please provide an input'
else
  arr = ARGV[0].to_array
  p arr.hash_inject
end