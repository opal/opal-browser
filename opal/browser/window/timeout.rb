module Browser; class Window

class Timeout < Native
  attr_reader :after

  def initialize(window, time, &block)
    @window = window
    @after  = time
    @block  = block

    super(`#@window.setTimeout(#{block.to_native}, time * 1000)`)
  end

  def abort
    `#@window.clearTimeout(#@native)`
  end

  alias stop abort
end

end; end
