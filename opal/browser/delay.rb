module Browser

# Allows you to delay the call to a function which gets called after the
# given time.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/Window.setTimeout
class Delay
  # @!attribute [r] after
  # @return [Float] the seconds after which the block is called
  attr_reader :after

  # Create and start a timeout.
  #
  # @param window [Window] the window to start the timeout on
  # @param time [Float] seconds after which the block is called
  def initialize(window, time, &block)
    @window = Native.convert(window)
    @after  = time
    @block  = block
  end

  # Abort the timeout.
  def abort
    `#@window.clearTimeout(#@id)`
  end

  # Start the delay.
  def start
    @id = `#@window.setTimeout(#{@block.to_n}, #@after * 1000)`
  end
end

class Window
  # Execute a block after the given seconds.
  #
  # @param time [Float] the seconds after it gets called
  #
  # @return [Delay] the object representing the timeout
  def after(time, &block)
    Delay.new(@native, time, &block).tap(&:start)
  end

  # Execute a block after the given seconds, you have to call [#start] on it
  # yourself.
  #
  # @param time [Float] the seconds after it gets called
  #
  # @return [Delay] the object representing the timeout
  def after!(time, &block)
    Delay.new(@native, time, &block)
  end
end

end

module Kernel
  # (see Browser::Window#after)
  def after(time, &block)
    $window.after(time, &block)
  end

  # (see Browser::Window#after!)
  def after!(time, &block)
    $window.after!(time, &block)
  end
end

class Proc
  # (see Browser::Window#after)
  def after(time)
    $window.after(time, &self)
  end

  # (see Browser::Window#after!)
  def after!(time)
    $window.after!(time, &self)
  end
end
