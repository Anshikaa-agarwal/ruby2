p 'start'
t = Thread.new { p 'thread' }
t.join 
p 'end'
