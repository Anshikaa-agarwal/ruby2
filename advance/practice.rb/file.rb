settings = {user: {name: "om", location: {city: "delhi", country: "india"}}, gender: "male"}

class B < Hash
  def initialize(hashh)
    @hashh = hashh
  end

  def method_missing(name, *args, &blk)
    val = @hashh[name.to_sym]
    if val.is_a?(Hash)
      self.class.new(val)
    else
      val
    end
  end
end

obj = B.new(settings)
p obj.user.location.country # india
p obj.user.name # om
