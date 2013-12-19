require 'browser/compatibility/window/animation_frame'

module Browser; class Window

class AnimationFrame
  def initialize(window, &block)
    @window = window
    @native = window.to_n

    @id = `#@native[#{vendored_request_method_name}](#{block.to_n})`
  end

  def cancel
    `#@native[#{vendored_cancel_method_name}](#{@id})`
  end

  def vendored_request_method_name
    'requestAnimationFrame'
  end

  def vendored_cancel_method_name
    'cancelAnimationFrame'
  end

end

end; end
