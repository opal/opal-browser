module Browser; class Window; class View

if Browser.supports? :window, :innerHeight
  def width
    `#@native.innerWidth`
  end

  def height
    `#@native.innerHeight`
  end
elsif Browser.supports :element, :clientHeight
  def height
    `#@native.document.documentElement.clientHeight`
  end

  def width
    `#@native.document.documentElement.clientWidth`
  end
end

end; end; end
