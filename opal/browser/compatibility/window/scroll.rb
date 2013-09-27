module Browser; class Window

unless C.has? `document.documentElement`, :scrollLeft
  if C.has? :pageXOffset
    def scroll(to = nil)
      if to
        x = to[:x] || scroll.x
        y = to[:y] || scroll.y

        `#@native.scrollTo(#{x}, #{y})`
      else
        Position.new(`#@native.pageXOffset`, `#@native.pageYOffset`)
      end
    end
  else
    def scroll(*)
      raise NotImplementedError, 'scroll on window not supported'
    end
  end
end

end; end
