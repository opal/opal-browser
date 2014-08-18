module Browser; class Window

# Allows access and manipulation of the {Window} size.
class Size
  # @private
  def initialize(window)
    @window = window
    @native = window.to_n
  end

  def set(*args)
    if Hash === args.first
      width, height = args.first.values_at(:width, :height)
    else
      width, height = args
    end

    width  ||= self.width
    height ||= self.height

    `#@native.resizeTo(#{width}, #{height})`

    self
  end

  # @!attribute width
  # @return [Integer] the width of the window

  # @!attribute height
  # @return [Integer] the height of the window

  if Browser.supports? 'Window.outerSize'
    def width
      `#@native.outerWidth`
    end

    def height
      `#@native.outerHeight`
    end
  else
    def width
      raise NotImplementedError, 'window outer size not supported'
    end

    def height
      raise NotImplementedError, 'window outer size not supported'
    end
  end

  def width=(value)
    set(width: value)
  end

  def height=(value)
    set(height: value)
  end
end

end; end
