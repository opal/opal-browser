module Browser; module DOM; class Element

unless Compatibility.has?(:Element, :matches)
  if Compatibility.has?(:Element, :oMatchesSelector)
    def matches?(selector)
      `#@native.oMatchesSelector(#{selector})`
    end
  elsif Compatibility.has?(:Element, :msMatchesSelector)
    def matches?(selector)
      `#@native.msMatchesSelector(#{selector})`
    end
  elsif Compatibility.has?(:Element, :mozMatchesSelector)
    def matches?(selector)
      `#@native.mozMatchesSelector(#{selector})`
    end
  elsif Compatibility.has?(:Element, :webkitMatchesSelector)
    def matches?(selector)
      `#@native.webkitMatchesSelector(#{selector})`
    end
  elsif Compatibility.sizzle?
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
