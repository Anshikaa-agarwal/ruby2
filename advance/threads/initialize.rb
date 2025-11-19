# t = Thread.new { puts 'hii' }
# t.join

class MyThread < Thread
  def initialize 
    super
    puts 'initialized mythread'
  end
end

t = MyThread.new { puts 'hello' }
sleep 1
t.join