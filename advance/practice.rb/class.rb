class Class
  def new(*arg)
    obj = allocate
    obj.send(:initialize, *arg)
    obj
  end
end
    