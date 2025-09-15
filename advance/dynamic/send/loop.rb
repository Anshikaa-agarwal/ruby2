# Write a loop that:

# Stores method names in an array: [:add, :subtract, :multiply].
# Randomly picks one method each iteration.
# Calls it dynamically with random numbers.
# Prints the method name, arguments, and result.
# Extra challenge: Track how many times each method was called.

operations_hash = {
  add: :+,
  subtract: :-,
  multiply: :*,
  divide: :/
}

# To track how many times each operation was used
operation_count = Hash.new(0)

10.times do |i|
  # Pick a random operation
  operation = operations_hash.keys.sample
  operand = operations_hash[operation]

  # Random operands
  first, second = rand(1..10).to_f, rand(1..10).to_f

  # Perform the operation using send
  result = first.send(operand, second)

  # Print nicely
  puts "Loop #{i + 1}: #{first} #{operand} #{second} = #{result}"

  # Increment the count
  operation_count[operation] += 1
end

puts "\nOperation usage count:"
operation_count.each do |op, count|
  puts "#{op}: #{count}"
end
