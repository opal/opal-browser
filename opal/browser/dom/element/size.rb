module Browser; module DOM; class Element < Node

class Size
  attr_reader :element

  # @private
  def initialize(element, *inc)
    @element = element
    @native  = element.to_n
    @include = inc
  end

  # @!attribute width
  # @return [Integer] the element width
  def width
    `#@native.offsetWidth`
  end

  def width=(value)
    @element.style[:width] = value
  end

  # @!attribute height
  # @return [Integer] the element height
  def height
    `#@native.offsetHeight`
  end

  def height=(value)
    @element.style[:height] = value
  end

  # @!attribute client_width
  # @return [Integer] the content-box width of an element
  def client_width
    `#@native.clientWidth`
  end

  # @!attribute client_height
  # @return [Integer] the content-box height of an element
  def client_height
    `#@native.clientHeight`
  end
end

end; end; end
