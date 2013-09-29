module Browser; class Window

class View
  def initialize(window)
    @window = window
    @native = window.to_n
  end

  def width
    `#@native.innerWidth`
  end

  def height
    `#@native.innerHeight`
  end
end

end; end
