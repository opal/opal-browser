module Browser; module DOM; class Element < Node

class Size
  attr_reader :element

  def initialize(element, *inc)
    @element = element
    @native  = element.to_n
    @include = inc
  end

  def width
    `#@native.offsetWidth`
  end

  def width=(value)
    @element.style[:width] = value
  end

  def height
    `#@native.offsetHeight`
  end

  def height=(value)
    @element.style[:height] = value
  end
end

end; end; end
