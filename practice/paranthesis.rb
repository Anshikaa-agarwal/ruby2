def valid_parentheses?(str)
  h = { "(" => ")", "[" => "]", "{" => "}" }
  stack = []
  arr = str.chars

  arr.each do |char|
    if h.key?char
      stack << char
    else
      return false if stack.empty? || stack.pop != h.key(char)
    end
  end

  return stack.empty?
end

puts valid_parentheses?("()")
puts valid_parentheses?("()[]{}")
puts valid_parentheses?("(]")
puts valid_parentheses?("([)]")
puts valid_parentheses?("{[]}")