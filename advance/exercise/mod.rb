module A
end

module B
end

class C
end

module E
end

module F
end

module G
end

module H
end

module I
end

class J < C
  include A
  prepend B
  extend I
  prepend E
  include F
  include G
end
J.ancestors