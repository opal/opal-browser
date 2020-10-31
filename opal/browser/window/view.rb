module Browser; class Window

class View
  def initialize(window)
    @window = window
    @native = window.to_n
  end

  if Browser.supports? 'Window.innerSize'
    def width
      `#@native.innerWidth`
    end

    def height
      `#@native.innerHeight`
    end
  elsif Browser.supports? 'Element.clientSize'
    def height
      `#@native.document.documentElement.clientHeight`
    end

    def width
      `#@native.document.documentElement.clientWidth`
    end
  else
    def width
      raise NotImplementedError, 'window size unsupported'
    end

    def height
      raise NotImplementedError, 'window size unsupported'
    end
  end

  # Get a device pixel ratio. Can be used to handle desktop browser
  # zoom, retina devices and custom screen scale for mobile devices.
  # Use $window.visual_viewport.scale to handle mobile zoom.
  def zoom
    `#@native.devicePixelRatio`
  end

  # Handle #pixel_ratio changes. This will trigger a block on zoom.
  def on_zoom &block
    %x{
      var mqString = "(resolution: " + #@native.devicePixelRatio + "dppx)";
      #@native.matchMedia(mqString).addListener(#{block.to_n});
    }
  end
end

end; end
