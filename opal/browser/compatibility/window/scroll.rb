module Browser; class Window; class Scroll

if Browser.supports? :window, :scrollLeft
  def position
    %x{
      var doc  = #@native.document,
          root = doc.documentElement,
          body = doc.body;

      var x = root.scrollLeft || body.scrollLeft,
          y = root.scrollTop  || body.scrollTop;
    }

    Position.new(`x`, `y`)
  end

  def x
    position.x
  end

  def y
    position.y
  end
elsif Browser.supports? :window, :pageXOffset
  def position
    Position.new(x, y)
  end

  def x
    `#@native.pageXOffset`
  end

  def y
    `#@native.pageYOffset`
  end
else
end

end; end; end
