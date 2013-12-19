require 'browser/compatibility/window/animation_frame'

module Browser; class Window

# FIXME: drop the method_defined? checks when require order is fixed
class AnimationFrame
  def initialize(window, &block)
    @window = window
    @native = window.to_n

    request &block
  end

  def request
    raise NotImplementedError, 'window requestAnimationFrame unsupported'
  end unless method_defined? :request

  def cancel
    raise NotImplementedError, 'window cancelAnimationFrame unsupported'
  end unless method_defined? :cancel

end

  # Execute a block to update an animation before the next repaint.
  #
  def request_animation_frame(&block)
    AnimationFrame.new(self, &block)
  end

end; end
