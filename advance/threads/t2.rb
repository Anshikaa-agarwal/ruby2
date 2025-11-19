puts "Main thread: #{Thread.current.object_id}"

t1 = Thread.new { puts "Child thread: #{Thread.current.object_id}" }

puts "Main thread: #{Thread.current.object_id}"
# t1.join
