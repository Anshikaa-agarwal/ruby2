class Hash
  alias new_keys keys
  def keys
    new_keys.reverse
  end
end

h = {a: 1, b: 2, c: 3}
p h.keys