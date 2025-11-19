class Hash
  alias new_old []=
  def []=(key, arg)
    arg = (arg.to_i)*2
    new_old(key, arg)
  end
end

h = {}
h[1]=(10)
puts h
# class User
# User[:a] # not found error
# User[:b] = 10

class User
  class << self
  def self.[]=(key, val)
    
  end
end
