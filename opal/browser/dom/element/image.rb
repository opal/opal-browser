module Browser; module DOM; class Element < Node

class Image < Element
  def complete?
    `#@native.complete`
  end

  def cross?
    `#@native.crossOrigin`
  end

  def height
    `#@native.naturalHeight`
  end

  def width
    `#@native.naturalWidth`
  end
end

end; end; end
