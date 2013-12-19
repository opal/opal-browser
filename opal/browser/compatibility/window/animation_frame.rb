module Browser; class Window

  class Compatibility
    def self.request?(prefix = nil)
      if prefix
        has?("#{prefix}RequestAnimationFrame")
      else
        has?(:requestAnimationFrame)
      end
    end

    def self.cancel?(prefix = nil)
      if prefix
        has?("#{prefix}CancelAnimationFrame")
      else
        has?(:cancelAnimationFrame)
      end
    end

    def self.cancel_request?(prefix = nil)
      if prefix
        has?("#{prefix}CancelRequestAnimationFrame")
      else
        has?(:cancelAnimationFrame)
      end
    end
  end

end; end

module Browser; class Window

class AnimationFrame
  if C.request?
    def request(&block)
      @id = `#@native.requestAnimationFrame(#{block.to_n})`
    end
  else
    %w{ webkit moz o ms }.each do |prefix|
      if C.request? prefix
        def request(&block)
          @id = `#@native[#{prefix}+'RequestAnimationFrame'](#{block.to_n})`
        end
      end
    end
  end
  if C.cancel?
    def cancel
      `#@native.cancelAnimationFrame(#{@id})`
    end
  else
    %w{ webkit moz o ms }.each do |prefix|
      if C.cancel? prefix
        def cancel
          `#@native[#{prefix}+'CancelAnimationFrame'](#{@id})`
        end
      elsif C.cancel_request? prefix
        def cancel
          `#@native[#{prefix}+'CancelRequestAnimationFrame'](#{@id})`
        end
      end
    end
  end
end

end; end
