module Browser; class Window

class Timeout
  attr_reader :after

  def initialize(window, time, &block)
    @window = window
    @after  = time
    @block  = block

    @id = `#@window.setTimeout(#{block.to_n}, time * 1000)`
  end

  def abort
    `#@window.clearTimeout(#@id)`
  end

  alias stop abort
end

end; end
