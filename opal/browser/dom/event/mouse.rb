module Browser; module DOM; class Event

class Mouse < Event
  Position = Struct.new(:x, :y)

  def alt?
    `#@native.altKey`
  end

  def ctrl?
    `#@native.ctrlKey`
  end

  def meta?
    `#@native.metaKey`
  end

  def shift?
    `#@native.shiftKey`
  end

  def button
    `#@native.button`
  end

  def client
    Position.new(`#@native.clientX`, `#@native.clientY`)
  end

  def layer
    Position.new(`#@native.layerX`, `#@native.layerY`) if `#@native.layerX`
  end

  def offset
    Position.new(`#@native.offsetX`, `#@native.offsetY`) if `#@native.offsetX`
  end

  def page
    Position.new(`#@native.pageX`, `#@native.pageY`) if `#@native.pageX`
  end

  def screen
    Position.new(`#@native.screenX`, `#@native.screenY`) if `#@native.screenX`
  end

  def ancestor
    Position.new(`#@native.x`, `#@native.y`) if `#@native.x`
  end

  def x
    screen.x
  end

  def y
    screen.y
  end

  def target
    DOM(`#@native.relatedTarget`)
  end

  def from
    DOM(`#@native.fromElement`)
  end

  def to
    DOM(`#@native.toElement`)
  end
end

end; end; end
