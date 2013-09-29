module Browser; class Window; class Scroll

unless C.has? `document.documentElement`, :scrollLeft
  if C.has? :pageXOffset
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
    def x
      raise NotImplementedError, 'window scroll unsupported'
    end

    def y
      raise NotImplementedError, 'window scroll unsupported'
    end
  end
end

end; end; end
