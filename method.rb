class Object
  def method_missing(name, *args, &blk)
    puts "no method here"
    Object.new.greet
  end
end

Kernel.greet