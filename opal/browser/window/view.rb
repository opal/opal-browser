module Browser; class Window

class View
  def initialize(window)
    @window = window
    @native = window.to_n
  end

  if Browser.supports? 'Window.innerSize'
    def width
      `#@native.innerWidth`
    end

    def height
      `#@native.innerHeight`
    end
  elsif Browser.supports? 'Element.clientSize'
    def height
      `#@native.document.documentElement.clientHeight`
    end

    def width
      `#@native.document.documentElement.clientWidth`
    end
  else
    def width
      raise NotImplementedError, 'window size unsupported'
    end

    def height
      raise NotImplementedError, 'window size unsupported'
    end
  end
end

end; end
