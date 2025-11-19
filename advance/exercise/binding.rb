# frozen_string_literal: false

puts 'Enter code through command line.'
puts 'Enter blank line to evaluate.'
puts "Enter 'q' to quit."

current_binding = binding
code = ''

count = 1

loop do
  print "irb: #{count}> "
  line = gets.chomp
  break if line.nil? || line.chomp == 'q'

  if line.chomp.empty?
    # evaluate if blank line is inputed
    begin
      output = eval(code)
      puts "=> #{output.inspect}"
      code = ''
    rescue => e
      puts "#{e.message} (#{e.class})"
      code = ''
    end
  else
    # add to overall code
    code << "\n" << line
  end

  count += 1
end