module Browser; module DOM; class Element

unless C.has? `document.body`, :scrollLeft
  if C.has? `document.body`, :pageXOffset
    def scroll(to = nil)
      if to
        if x = to[:x]
          `#@native.pageXOffset = #{x}`
        end

        if y = to[:y]
          `#@native.pageYOffset = #{y}`
        end
      else
        Position.new(`#@native.pageXOffset`, `#@native.pageYOffset`)
      end
    end
  else
    def scroll(*)
      raise NotImplementedError, 'scroll on element not supported'
    end
  end
end

end; end; end
