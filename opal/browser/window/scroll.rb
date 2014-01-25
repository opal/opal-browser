module Browser; class Window

class Scroll
  def initialize(window)
    @window = window
    @native = window.to_n
  end

  if Browser.supports? 'Window.scroll'
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
  elsif Browser.supports? 'Window.pageOffset'
    def position
      Position.new(`#@native.pageXOffset`, `#@native.pageYOffset`)
    end
  else
    def position
      raise NotImplementedError, 'window scroll unsupported'
    end
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
