module Browser; module DOM; class Element < Node

class Scroll
  def initialize(element)
    @element = element
    @native  = element.to_n
  end

  def position
    Browser::Position.new(`#@native.scrollLeft`, `#@native.scrollTop`)
  end

  def x
    position.x
  end

  def y
    position.y
  end

  def to(what)
    x   = what[:x] || self.x
    y   = what[:y] || self.y

    `#@native.scrollTop = #{y}`
    `#@native.scrollLeft = #{x}`

    self
  end

  def by(what)
    x = what[:x] || 0
    y = what[:y] || 0

    `#@native.scrollBy(#{x}, #{y})`

    self
  end
end

end; end; end
