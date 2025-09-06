# Remove duplicates without using .uniq and Preserves first-seen order
class Array
  def remove_duplicates
    self.tally.keys
  end
end

arr = [1, 2, 3, "a", 3, 2, "a", :a, 1, 4, 4, nil]
p arr.remove_duplicates