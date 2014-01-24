module Browser; class Window; class Size

if Browser.supports? :window, :outerHeight
  def width
    `#@native.outerWidth`
  end

  def height
    `#@native.outerHeight`
  end
end

end; end; end
