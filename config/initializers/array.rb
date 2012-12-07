class Array

  def average
    if self.length == 0
      0
    else
      self.sum / self.length
    end
  end

end