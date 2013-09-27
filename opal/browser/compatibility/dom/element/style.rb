module Browser; module DOM; class Element

unless C.has? :getComputedStyle
  if C.has?(`document.documentElement`, :currentStyle)
    def style!
      CSS::Declaration.new(`#@native.currentStyle`)
    end
  else
    def style!
      raise NotImplementedError, 'computed style unsupported'
    end
  end
end

end; end; end
