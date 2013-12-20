require 'browser/compatibility/animation_frame'

module Browser

# FIXME: drop the method_defined? checks when require order is fixed
class AnimationFrame
  def initialize(window, &block)
    @window = window
    @native = window.to_n
    @id     = request(block)
  end

  def request
    raise NotImplementedError, 'window requestAnimationFrame unsupported'
  end unless method_defined? :request

  def cancel
    raise NotImplementedError, 'window cancelAnimationFrame unsupported'
  end unless method_defined? :cancel
end

end

class Proc
  # Execute a block to update an animation before the next repaint.
  def animation_frame
    Browser::AnimationFrame.new($window, &self)
  end
end
