module Browser; module DOM; class Element

if Browser.supports? :getComputedStyle
  def style!
    CSS::Declaration.new(`#{window.to_n}.getComputedStyle(#@native, null)`)
  end
elsif Browser.supports? :currentStyle
  def style!
    CSS::Declaration.new(`#@native.currentStyle`)
  end
end

end; end; end
