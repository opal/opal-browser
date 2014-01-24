module Browser; module DOM; class Document < Element

if Browser.supports? :document, :defaultView
  def window
    Window.new(`#@native.defaultView`)
  end
elsif Browser.supports? :document, :parentWindow
  def window
    Window.new(`#@native.parentWindow`)
  end
end

end; end; end
