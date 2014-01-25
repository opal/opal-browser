module Browser

class AnimationFrame
  def initialize(window, &block)
    @window = window
    @native = window.to_n
    @id     = request(block)
  end

  if Browser.supports? 'Animation.request'
    def request(block)
      `#@native.requestAnimationFrame(#{block.to_n})`
    end
  elsif Browser.supports? 'Animation.request (Chrome)'
    def request(block)
      `#@native.webkitRequestAnimationFrame(#{block.to_n})`
    end
  elsif Browser.supports? 'Animation.request (Firefox)'
    def request(block)
      `#@native.mozRequestAnimationFrame(#{block.to_n})`
    end
  elsif Browser.supports? 'Animation.request (Opera)'
    def request(block)
      `#@native.oRequestAnimationFrame(#{block.to_n})`
    end
  elsif Browser.supports? 'Animation.request (Internet Explorer)'
    def request(block)
      `#@native.msRequestAnimationFrame(#{block.to_n})`
    end
  else
    def request
      raise NotImplementedError, 'window requestAnimationFrame unsupported'
    end
  end

  if Browser.supports? 'Animation.cancel'
    def cancel
      `#@native.cancelAnimationFrame(#@id)`
    end
  elsif Browser.supports? 'Animation.cancel (Chrome)'
    def cancel
      `#@native.webkitCancelAnimationFrame(#@id)`
    end
  elsif Browser.supports? 'Animation.cancelRequest (Chrome)'
    def cancel
      `#@native.webkitCancelRequestAnimationFrame(#@id)`
    end
  elsif Browser.supports? 'Animation.cancel (Firefox)'
    def cancel
      `#@native.mozCancelAnimationFrame(#@id)`
    end
  elsif Browser.supports? 'Animation.cancelRequest (Firefox)'
    def cancel
      `#@native.mozCancelRequestAnimationFrame(#@id)`
    end
  elsif Browser.supports? 'Animation.cancel (Opera)'
    def cancel
      `#@native.oCancelAnimationFrame(#@id)`
    end
  elsif Browser.supports? 'Animation.cancelRequest (Opera)'
    def cancel
      `#@native.oCancelRequestAnimationFrame(#@id)`
    end
  elsif Browser.supports? 'Animation.cancel (Internet Explorer)'
    def cancel
      `#@native.msCancelAnimationFrame(#@id)`
    end
  elsif Browser.supports? 'Animation.cancelRequest (Internet Explorer)'
    def cancel
      `#@native.msCancelRequestAnimationFrame(#@id)`
    end
  else
    def cancel
      raise NotImplementedError, 'window cancelAnimationFrame unsupported'
    end
  end
end

end

class Proc
  # Execute a block to update an animation before the next repaint.
  def animation_frame
    Browser::AnimationFrame.new($window, &self)
  end
end
