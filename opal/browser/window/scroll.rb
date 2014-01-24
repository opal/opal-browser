module Browser; class Window

class Scroll
  def initialize(window)
    @window = window
    @native = window.to_n
  end

  # @abstract
  def position
    raise NotImplementedError, 'window scroll unsupported'
  end

  # @abstract
  def x
    raise NotImplementedError, 'window scroll unsupported'
  end

  # @abstract
  def y
    raise NotImplementedError, 'window scroll unsupported'
  end

  def to(what)
    x   = what[:x] || self.x
    y   = what[:y] || self.y

    `#@native.scrollTo(#{x}, #{y})`

    self
  end

  def by(what)
    x = what[:x] || 0
    y = what[:y] || 0

    `#@native.scrollBy(#{x}, #{y})`

    self
  end
end

end; end
