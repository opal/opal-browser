module Browser; class Window; class View

unless C.has? :innerHeight
  def width
    `#@native.document.documentElement.clientWidth`
  end

  def height
    `#@native.document.documentElement.clientHeight`
  end
end

end; end; end
