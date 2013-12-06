#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Browser; class Canvas

class Data
  def self.create(context, width, height)
    data = allocate

    data.instance_eval {
      @context = context
      @x       = 0
      @y       = 0
      @width   = width
      @height  = height

      @native = `#{context.to_n}.createImageData(width, height)`
    }

    data
  end

  include Native

  attr_reader :x, :y, :width, :height

  def initialize(context, x, y, width, height)
    @context = context
    @x       = x
    @y       = y
    @width   = width
    @height  = height

    super(`#{@context.to_n}.getImageData(x, y, width, height)`)
  end

  def length
    `#@native.length`
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

    `#{@context.to_n}.putImageData(#@native, x, y)`
  end

  def save_to(context, x = nil, y = nil)
    x ||= 0
    y ||= 0

    `#{context.to_n}.putImageData(#@native, x, y)`
  end

  alias size length
end

end; end
