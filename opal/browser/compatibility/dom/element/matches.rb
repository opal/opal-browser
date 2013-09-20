module Browser; module DOM; class Element

unless defined?(`window.Element.prototype.matches`)
  if defined?(`window.Element.prototype.oMatchesSelector`)
    def matches?(selector)
      `#@native.oMatchesSelector(#{selector})`
    end
  elsif defined?(`window.Element.prototype.msMatchesSelector`)
    def matches?(selector)
      `#@native.msMatchesSelector(#{selector})`
    end
  elsif defined?(`window.Element.prototype.mozMatchesSelector`)
    def matches?(selector)
      `#@native.mozMatchesSelector(#{selector})`
    end
  elsif defined?(`window.Element.prototype.webkitMatchesSelector`)
    def matches?(selector)
      `#@native.webkitMatchesSelector(#{selector})`
    end
  else
    raise NotImplementedError, 'matches by selector unsupported'
  end
end

end; end; end
