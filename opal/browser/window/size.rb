module Browser; class Window

class Size
  def initialize(window)
    @window = window
    @native = window.to_n
  end

  def set(what)
    width  = what[:width]  || self.width
    height = what[:height] || self.height

    `#@native.resizeTo(#{width}, #{height})`

    self
  end

  # @abstract
  def width
    raise NotImplementedError, 'window outer size not supported'
  end

  # @abstract
  def height
    raise NotImplementedError, 'window outer size not supported'
  end

  def width=(value)
    set(width: value)
  end

  def height=(value)
    set(height: value)
  end
end

end; end
