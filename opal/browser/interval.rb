module Browser

class Interval
  attr_reader :every

  def initialize(window, time, &block)
    @window = window
    @every  = time
    @block  = block

    @id = `#@window.setInterval(#{block.to_n}, time * 1000)`
  end

  def abort
    `#@window.clearInterval(#@id)`
  end

  alias stop abort
end

end
