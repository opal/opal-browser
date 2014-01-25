module Browser; module DOM; class Element < Node

class Scroll
  def initialize(element)
    @element = element
    @native  = element.to_n
  end

  if Browser.supports? 'Element.scroll'
    def to(what)
      x   = what[:x] || self.x
      y   = what[:y] || self.y

      `#@native.scrollTop  = #{y}`
      `#@native.scrollLeft = #{x}`
    end

    def position
      Browser::Position.new(`#@native.scrollLeft`, `#@native.scrollTop`)
    end
  elsif Browser.supports? 'Element.pageOffset'
    def to(what)
      x   = what[:x] || self.x
      y   = what[:y] || self.y

      `#@native.pageYOffset = #{y}`
      `#@native.pageXOffset = #{x}`
    end

    def position
      Position.new(`#@native.pageXOffset`, `#@native.pageYOffset`)
    end
  else
    def to(what)
      raise NotImplementedError, 'scroll on element unsupported'
    end

    def position
      raise NotImplementedError, 'scroll on element unsupported'
    end
  end

  def x
    position.x
  end

  def y
    position.y
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
