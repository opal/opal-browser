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

  if Browser.supports? 'Window.outerSize'
    def width
      `#@native.outerWidth`
    end

    def height
      `#@native.outerHeight`
    end
  else
    def width
      raise NotImplementedError, 'window outer size not supported'
    end

    def height
      raise NotImplementedError, 'window outer size not supported'
    end
  end

  def width=(value)
    set(width: value)
  end

  def height=(value)
    set(height: value)
  end
end

end; end
