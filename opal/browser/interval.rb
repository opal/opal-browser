module Browser

# This class wraps `setInterval`.
class Interval
  # @!attribute [r] every
  # @return [Number] the seconds every which the block is called
  attr_reader :every

  # Create and start an interval.
  #
  # @param window [Window] the window to start the interval on
  # @param time [Number] seconds every which to call the block
  def initialize(window, time, &block)
    @window = Native.convert(window)
    @every  = time
    @block  = block

    @aborted = false
    @stopped = true

    start
  end

  # Check if the interval has been stopped.
  def stopped?
    @stopped
  end

  # Check if the interval has been aborted.
  def aborted?
    @aborted
  end

  # Abort the interval, it won't be possible to start it again.
  #
  # @return [self]
  def abort
    `#@window.clearInterval(#@id)`

    @aborted = true
    @id      = nil

    self
  end

  # Stop the interval, it will be possible to start it again.
  #
  # @return [self]
  def stop
    `#@window.clearInterval(#@id)`

    @stopped = true
    @id      = nil
  end

  # Start the interval if it has been stopped.
  #
  # @return [self]
  def start
    raise "the interval has been aborted" if aborted?

    return unless stopped?

    @id = `#@window.setInterval(#{@block.to_n}, #@every * 1000)`

    self
  end
end

class Window
  # Execute the block every given seconds.
  #
  # @param time [Float] the seconds between every call
  # @return [Interval] the object representing the interval
  def every(time, &block)
    Interval.new(@native, time, &block)
  end
end

end

class Proc
  def every(time)
    $window.every(time, &self)
  end
end

module Kernel
  # (see Browser::Window#every)
  def every(time, &block)
    $window.every(time, &block)
  end
end
