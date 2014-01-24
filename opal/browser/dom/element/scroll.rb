module Browser; module DOM; class Element < Node

class Scroll
  def initialize(element)
    @element = element
    @native  = element.to_n
  end

  # @abstract
  def position
    raise NotImplementedError, 'scroll on element unsupported'
  end

  def x
    position.x
  end

  def y
    position.y
  end

  # @abstract
  def to(what)
    raise NotImplementedError, 'scroll on element unsupported'
  end

  def height
    `#@native.scrollHeight`
  end

  def width
    `#@native.scrollWidth`
  end

  def by(what)
    x = what[:x] || 0
    y = what[:y] || 0

    `#@native.scrollBy(#{x}, #{y})`

    self
  end
end

end; end; end
