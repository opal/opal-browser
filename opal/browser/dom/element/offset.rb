module Browser; module DOM; class Element < Node

class Offset
  def initialize(element)
    @element = element
    @native  = element.to_n
  end

  def parent
    DOM(`#@native.offsetParent || #{@element.document.root.to_n}`)
  end

  def x
    position.x
  end

  def y
    position.y
  end

  def position
    doc  = @element.document
    root = doc.root.to_n
    win  = doc.window.to_n

    %x{
      var box = #@native.getBoundingClientRect(),
          y   = box.top + (#{win}.pageYOffset || #{root}.scrollTop) - (#{root}.clientTop || 0),
          x   = box.left + (#{win}.pageXOffset || #{root}.scrollLeft) - (#{root}.clientLeft || 0);
    }

    Browser::Position.new(`x`, `y`)
  end

  def position=(value)

  end
end

end; end; end
