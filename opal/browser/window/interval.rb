module Browser; class Window < Native

class Interval < Native
  attr_reader :every

  def initialize(window, time, &block)
    @window = window
    @every  = time
    @block  = block

    super(`#@window.setInterval(#{block.to_native}, time * 1000)`)
  end

  def abort
    `#@window.clearInterval(#@native)`
  end

  alias stop abort
end

end; end
