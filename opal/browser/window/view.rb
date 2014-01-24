module Browser; class Window

class View
  def initialize(window)
    @window = window
    @native = window.to_n
  end

  # @abstract
  def width
    raise NotImplementedError, 'window size unsupported'
  end

  # @abstract
  def height
    raise NotImplementedError, 'window size unsupported'
  end
end

end; end
