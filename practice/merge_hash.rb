def mergee(h1, h2)
  h = h1.dup
  h2.each do |key, val|
    if h.key?(key)
      h[key] = block_given? ? yield(h[key], val) : [h[key], val]
    else
      h[key] = val
    end
  end
  h
end

h1 = {a: 1, b: 2, c: 3}
h2 = {a: 3, b: 1, d: 7}

p mergee(h1, h2)
p mergee(h1, h2) { |old, new| old + new }