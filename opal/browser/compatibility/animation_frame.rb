module Browser

class Compatibility
  def self.request_animation?(prefix = nil)
    if prefix
      has?("#{prefix}RequestAnimationFrame")
    else
      has?(:requestAnimationFrame)
    end
  end

  def self.cancel_animation?(prefix = nil)
    if prefix
      has?("#{prefix}CancelAnimationFrame")
    else
      has?(:cancelAnimationFrame)
    end
  end

  def self.cancel_request_animation?(prefix = nil)
    if prefix
      has?("#{prefix}CancelRequestAnimationFrame")
    else
      has?(:cancelAnimationFrame)
    end
  end
end

class AnimationFrame
  if C.request_animation?
    def request(block)
      `#@native.requestAnimationFrame(#{block.to_n})`
    end
  elsif C.request_animation? :webkit
    def request(block)
      `#@native.webkitRequestAnimationFrame(#{block.to_n})`
    end
  elsif C.request_animation? :moz
    def request(block)
      `#@native.mozRequestAnimationFrame(#{block.to_n})`
    end
  elsif C.request_animation? :o
    def request(block)
      `#@native.oRequestAnimationFrame(#{block.to_n})`
    end
  elsif C.request_animation? :ms
    def request(block)
      `#@native.msRequestAnimationFrame(#{block.to_n})`
    end
  end

  if C.cancel_animation?
    def cancel
      `#@native.cancelAnimationFrame(#@id)`
    end
  else
    if C.cancel_animation? :webkit
      def cancel
        `#@native.webkitCancelAnimationFrame(#@id)`
      end
    elsif C.cancel_request_animation? :webkit
      def cancel
        `#@native.webkitCancelRequestAnimationFrame(#@id)`
      end
    elsif C.cancel_animation? :moz
      def cancel
        `#@native.mozCancelAnimationFrame(#@id)`
      end
    elsif C.cancel_request_animation? :moz
      def cancel
        `#@native.mozCancelRequestAnimationFrame(#@id)`
      end
    elsif C.cancel_animation? :o
      def cancel
        `#@native.oCancelAnimationFrame(#@id)`
      end
    elsif C.cancel_request_animation? :o
      def cancel
        `#@native.oCancelRequestAnimationFrame(#@id)`
      end
    elsif C.cancel_animation? :ms
      def cancel
        `#@native.msCancelAnimationFrame(#@id)`
      end
    elsif C.cancel_request_animation? :ms
      def cancel
        `#@native.msCancelRequestAnimationFrame(#@id)`
      end
    end
  end
end

end
