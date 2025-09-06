class Array
  def group_anagrams
    group_by { |str| str.chars.sort.join }.values
  end
end

arr = ["cat", "dog", "ogd", "act", "sky", "god"]
p arr.group_anagrams