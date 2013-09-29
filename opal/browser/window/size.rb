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

  def width
    `#@native.outerWidth`
  end

  def width=(value)
    set(width: value)
  end

  def height
    `#@native.outerHeight`
  end

  def height=(value)
    set(height: value)
  end
end

end; end
