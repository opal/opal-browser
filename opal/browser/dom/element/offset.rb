module Browser; module DOM; class Element < Node

class Offset
  attr_reader :element

  # @private
  def initialize(element)
    @element = element
    @native  = element.to_n
  end

  def parent
    DOM(`#@native.offsetParent || #{@element.document.root.to_n}`)
  end

  # @!attribute x
  # @return [Integer]
  def x
    get.x
  end

  def x=(value)
    set value, nil
  end

  # @!attribute y
  # @return [Integer]
  def y
    get.y
  end

  def y=(value)
    set nil, value
  end

  if Browser.supports? 'Element.getBoundingClientRect'
    def get
      doc  = @element.document
      root = doc.root.to_n
      win  = doc.window.to_n

      %x{
        var box = #@native.getBoundingClientRect(),
            y   = box.top + (#{win}.pageYOffset || #{root}.scrollTop) - (#{root}.clientTop || 0),
            x   = box.left + (#{win}.pageXOffset || #{root}.scrollLeft) - (#{root}.clientLeft || 0);
      }

      Browser::Position.new(`x`, `y`)
    end
  else
    def get
      doc  = document
      root = doc.root.to_n
      win  = doc.window.to_n

      %x{
        var y = (#{win}.pageYOffset || #{root}.scrollTop) - (#{root}.clientTop || 0),
            x = (#{win}.pageXOffset || #{root}.scrollLeft) - (#{root}.clientLeft || 0);
      }

      Browser::Position.new(`x`, `y`)
    end
  end

  def set(*value)
    position = @element.style![:position]

    if position == :static
      @element.style[:position] = :relative
    end

    offset = get
    top    = @element.style![:top].to_u
    left   = @element.style![:left].to_u

    if Browser::Position === value.first
      x, y = value.first.x, value.first.y
    elsif Hash === value.first
      x, y = value.first[:x], value.first[:y]
    else
      x, y = value
    end

    @element.style[:left] = (x.px - offset.x) + left if x
    @element.style[:top]  = (y.px - offset.y) + top  if y
  end
end

end; end; end
