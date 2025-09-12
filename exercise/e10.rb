# frozen_string_literal: true

# class Array to inject in hash
class Array
  def split_by_length
    acc = Hash.new { |hash, key| hash[key] = Hash.new { |in_hash, in_key| in_hash[in_key] = [] } }
    inject(acc) do |memo, element|
      len = element.length
      type = len.odd? ? 'odd' : 'even'

      memo[type][len] << element
      memo
    end.transform_values(&:values)
  end
end

# monkeypatching String for input conversion
class String
  def to_array
    gsub(/[\[\]']/, '').split(',')
  end
end

if ARGV.empty?
  puts 'Please provide an input'
else
  arr = ARGV[0].to_array
  p arr.split_by_length
end