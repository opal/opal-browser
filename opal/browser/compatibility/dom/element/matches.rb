module Browser; module DOM; class Element < Node

if Browser.supports? :element, :matches
  def matches?(selector)
    `#@native.matches(#{selector})`
  end
elsif Browser.supports? :element, :matches, :opera
  def matches?(selector)
    `#@native.oMatchesSelector(#{selector})`
  end
elsif Browser.supports? :element, :matches, :ie
  def matches?(selector)
    `#@native.msMatchesSelector(#{selector})`
  end
elsif Browser.supports? :element, :matches, :firefox
  def matches?(selector)
    `#@native.mozMatchesSelector(#{selector})`
  end
elsif Browser.supports? :element, :matches, :chrome
  def matches?(selector)
    `#@native.webkitMatchesSelector(#{selector})`
  end
elsif Browser.loaded? :sizzle
  def matches?(selector)
    `Sizzle.matchesSelector(#@native, #{selector})`
  end
end

end; end; end
