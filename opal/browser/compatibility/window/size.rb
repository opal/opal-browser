module Browser; class Window; class Size

unless C.has? :outerHeight
  def width
    raise NotImplementedError, 'window outer size not supported'
  end

  def height
    raise NotImplementedError, 'window outer size not supported'
  end
end

end; end; end
