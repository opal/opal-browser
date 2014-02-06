module Browser; class Canvas

class Data
  def self.create(canvas, width, height)
    data = allocate

    data.instance_eval {
      @canvas = canvas.to_a
      @x      = 0
      @y      = 0
      @width  = width
      @height = height

      @native = `#{canvas.to_n}.createImageData(width, height)`
    }

    data
  end

  include Native

  attr_reader :x, :y, :width, :height

  def initialize(canvas, x, y, width, height)
    @canvas = canvas.to_n
    @x      = x
    @y      = y
    @width  = width
    @height = height

    super(`#@canvas.getImageData(x, y, width, height)`)
  end

  def length
    `#@native.data.length`
  end

  def [](index)
    `#@native.data[index]`
  end

  def []=(index, value)
    `#@native.data[index] = value`
  end

  def save(x = nil, y = nil)
    x ||= 0
    y ||= 0

    `#@canvas.putImageData(#@native, x, y)`
  end

  def save_to(canvas, x = nil, y = nil)
    x ||= 0
    y ||= 0

    `#{canvas.to_n}.putImageData(#@native, x, y)`
  end

  alias size length
end

end; end
