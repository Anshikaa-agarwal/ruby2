

class Integer
  def +(val)
    a = self
    val.times {a = a.succ}
    a.succ
  end
end

p (13+21)