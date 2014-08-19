module Browser; module DOM; class Element < Node

class Scroll
  attr_reader :element

  # @private
  def initialize(element)
    @element = element
    @native  = element.to_n
  end

  if Browser.supports? 'Element.scroll'
    def to(*args)
      if Hash === args.first
        x = args.first[:x] || self.x
        y = args.first[:y] || self.y
      else
        x, y = args
      end

      `#@native.scrollTop  = #{y}`
      `#@native.scrollLeft = #{x}`
    end

    def position
      Browser::Position.new(`#@native.scrollLeft`, `#@native.scrollTop`)
    end
  elsif Browser.supports? 'Element.pageOffset'
    def to(*args)
      if Hash === args.first
        x = args.first[:x] || self.x
        y = args.first[:y] || self.y
      else
        x, y = args
      end

      `#@native.pageYOffset = #{y}`
      `#@native.pageXOffset = #{x}`
    end

    def position
      Position.new(`#@native.pageXOffset`, `#@native.pageYOffset`)
    end
  else
    # @overload to(x, y)
    #
    #   Scroll to the given x and y.
    #
    #   @param x [Integer] scroll to x on the x axis
    #   @param y [Integer] scroll to y on the y axis
    #
    # @overload to(hash)
    #
    #   Scroll to the given x and y.
    #
    #   @param hash [Hash] the descriptor
    #
    #   @option hash [Integer] :x scroll to x on the x axis
    #   @option hash [Integer] :y scroll to y on the y axis
    def to(*args)
      raise NotImplementedError, 'scroll on element unsupported'
    end

    def position
      raise NotImplementedError, 'scroll on element unsupported'
    end
  end

  # @!attribute [r] x
  # @return [Integer] the scroll position on the x axis
  def x
    position.x
  end

  # @!attribute [r] y
  # @return [Integer] the scroll position on the y axis
  def y
    position.y
  end

  # @!attribute [r] height
  # @return [Integer] the height of the scroll
  def height
    `#@native.scrollHeight`
  end

  # @!attribute [r] width
  # @return [Integer] the width of the scroll
  def width
    `#@native.scrollWidth`
  end

  # @overload by(x, y)
  #
  #   Scroll by the given x and y.
  #
  #   @param x [Integer] scroll by x on the x axis
  #   @param y [Integer] scroll by y on the y axis
  #
  # @overload by(hash)
  #
  #   Scroll by the given x and y.
  #
  #   @param hash [Hash] the descriptor
  #
  #   @option hash [Integer] :x scroll by x on the x axis
  #   @option hash [Integer] :y scroll by y on the y axis
  def by(*args)
    if Hash === args.first
      x = args.first[:x] || 0
      y = args.first[:y] || 0
    else
      x, y = args
    end

    `#@native.scrollBy(#{x}, #{y})`

    self
  end

  if Browser.supports? 'Element.scrollIntoViewIfNeeded'
    def to(align = true)
      `#@native.scrollIntoViewIfNeeded(align)`
    end
  else
    def to(align = true)
      raise NotImplementedError
    end
  end

  def to!(align = true)
    `#@native.scrollIntoView(align)`
  end
end

end; end; end
