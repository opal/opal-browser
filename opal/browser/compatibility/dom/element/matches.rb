module Browser; module DOM; class Element

unless C.respond_to?(:Element, :matches)
  if C.respond_to?(:Element, :oMatchesSelector)
    def matches?(selector)
      `#@native.oMatchesSelector(#{selector})`
    end
  elsif C.respond_to?(:Element, :msMatchesSelector)
    def matches?(selector)
      `#@native.msMatchesSelector(#{selector})`
    end
  elsif C.respond_to?(:Element, :mozMatchesSelector)
    def matches?(selector)
      `#@native.mozMatchesSelector(#{selector})`
    end
  elsif C.respond_to?(:Element, :webkitMatchesSelector)
    def matches?(selector)
      `#@native.webkitMatchesSelector(#{selector})`
    end
  elsif C.sizzle?
    def matches?(selector)
      `Sizzle.matchesSelector(#@native, #{selector})`
    end
  else
    def matches?(*)
      raise NotImplementedError, 'matches by selector unsupported'
    end
  end
end

end; end; end
