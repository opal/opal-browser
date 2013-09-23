module Browser

# This class wraps `setTimeout`.
class Timeout
  # @!attribute [r] after
  # @return [Number] the seconds after which the block is called
  attr_reader :after

  # Create and start a timeout.
  #
  # @param window [Window] the window to start the timeout on
  # @param time [Number] seconds after which the block is called
  def initialize(window, time, &block)
    @window = Native.convert(window)
    @after  = time
    @block  = block

    @id = `#@window.setTimeout(#{block.to_n}, time * 1000)`
  end

  # Abort the timeout.
  #
  # @return [self]
  def abort
    `#@window.clearTimeout(#@id)`

    self
  end
end

end
