module Browser; module DOM; class Element < Node

# @todo Consider using the new interfaces which allow for optional
#       smooth transitions.
class Scroll
  attr_reader :element

  # @private
  def initialize(element)
    @element = element
    @native  = element.to_n

    # Portable support for Window#scroll and Document#scroll
    @scrolling_native = @native
    if [Document, Window].include?(@element.class)
      # If we are a window, let's become a document first.
      if defined? `#@scrolling_native.document`
        @scrolling_native = `#@scrolling_native.document`
      end
      # There were slight disagreements in the past which element
      # should we handle.
      if defined? `#@scrolling_native.documentElement.scrollTop`
        @scrolling_native = `#@scrolling_native.documentElement`
      elsif defined? `#@scrolling_native.body.scrollTop`
        @scrolling_native = `#@scrolling_native.body`
      end
    end
  end

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
  #
  # @overload to(symbol)
  #
  #   Scroll to :top or to :bottom
  #
  #   @param symbol [Symbol] either :top or :bottom
  def to(*args)
    x, y = nil, nil
    case args.first
    when Hash
      x = args.first[:x]
      y = args.first[:y]
    when :top
      y = 0
    when :bottom
      y = 99999999
    else
      x, y = args
    end

    set(x, y) if x || y

    self
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
    case args.first
    when Hash
      x = args.first[:x] || 0
      y = args.first[:y] || 0
    else
      x, y = args
    end

    set_by(x, y)

    self
  end

  if Browser.supports? 'Element.scrollBy'
    private def set_by(x, y)
      `#@scrolling_native.scrollBy(#{x}, #{y})`
    end
  else
    private def set_by(x, y)
      set(self.x + x, self.y + y)
    end
  end

  if Browser.supports? 'Element.scroll'
    private def set(x=nil, y=nil)
      `#@scrolling_native.scrollTop  = #{y}` if y
      `#@scrolling_native.scrollLeft = #{x}` if x
    end

    def position
      Browser::Position.new(`#@scrolling_native.scrollLeft`, `#@scrolling_native.scrollTop`)
    end
  else
    private def set(x=nil, y=nil)
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
    `#@scrolling_native.scrollHeight`
  end

  # @!attribute [r] width
  # @return [Integer] the width of the scroll
  def width
    `#@scrolling_native.scrollWidth`
  end

  if Browser.supports? 'Element.scrollIntoViewIfNeeded'
    def into_view(align = true)
      `#@scrolling_native.scrollIntoViewIfNeeded(align)`
    end
  else
    # Non-standard. Not supported by modern Firefox. Use {#into_view!}
    def into_view(align = true)
      raise NotImplementedError
    end
  end

  def into_view!(align = true)
    `#@scrolling_native.scrollIntoView(align)`
  end
end

end; end; end
