module Browser; module DOM; class Element < Node; class Scroll

if Browser.supports? :element, :scrollLeft
  def position
    Browser::Position.new(`#@native.scrollLeft`, `#@native.scrollTop`)
  end

  def to(what)
    x   = what[:x] || self.x
    y   = what[:y] || self.y

    `#@native.scrollTop  = #{y}`
    `#@native.scrollLeft = #{x}`
  end
elsif Browser.supports? :element, :pageXOffset
  def position
    Position.new(`#@native.pageXOffset`, `#@native.pageYOffset`)
  end

  def to(what)
    x   = what[:x] || self.x
    y   = what[:y] || self.y

    `#@native.pageYOffset = #{y}`
    `#@native.pageXOffset = #{x}`
  end
end

end; end; end; end
