class Hash
  alias new_old []=
  def []=(key, arg)
    new_old(key, arg.to_s)
  end
end

h = {}
h[:a] = :abc
h[:b] = 1
h[:c] = nil
h[:d] = 1.02
p h