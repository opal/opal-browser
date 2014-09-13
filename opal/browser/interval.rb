module Browser

# Allows you to create an interval that executes the function every given
# seconds.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/Window.setInterval
class Interval
  # @!attribute [r] every
  # @return [Float] the seconds every which the block is called
  attr_reader :every

  # Create and start an interval.
  #
  # @param window [Window] the window to start the interval on
  # @param time [Float] seconds every which to call the block
  def initialize(window, time, &block)
    @window = Native.convert(window)
    @every  = time
    @block  = block

    @aborted = false
  end

  # Check if the interval has been stopped.
  def stopped?
    @id.nil?
  end

  # Check if the interval has been aborted.
  def aborted?
    @aborted
  end

  # Abort the interval, it won't be possible to start it again.
  def abort
    `#@window.clearInterval(#@id)`

    @aborted = true
    @id      = nil
  end

  # Stop the interval, it will be possible to start it again.
  def stop
    return if stopped?

    `#@window.clearInterval(#@id)`

    @stopped = true
    @id      = nil
  end

  # Start the interval if it has been stopped.
  def start
    raise "the interval has been aborted" if aborted?
    return unless stopped?

    @id = `#@window.setInterval(#@block, #@every * 1000)`
  end

  # Call the [Interval] block.
  def call
    @block.call
  end
end

class Window
  # Execute the block every given seconds.
  #
  # @param time [Float] the seconds between every call
  #
  # @return [Interval] the object representing the interval
  def every(time, &block)
    Interval.new(@native, time, &block).tap(&:start)
  end

  # Execute the block every given seconds, you have to call [#start] on it
  # yourself.
  #
  # @param time [Float] the seconds between every call
  #
  # @return [Interval] the object representing the interval
  def every!(time, &block)
    Interval.new(@native, time, &block)
  end
end

end

module Kernel
  # (see Browser::Window#every)
  def every(time, &block)
    $window.every(time, &block)
  end

  # (see Browser::Window#every!)
  def every!(time, &block)
    $window.every!(time, &block)
  end
end

class Proc
  # (see Browser::Window#every)
  def every(time)
    $window.every(time, &self)
  end

  # (see Browser::Window#every!)
  def every!(time)
    $window.every!(time, &self)
  end
end
