module Browser; module DOM; class Element < Node

class Size
  include Native::Wrapper

  attr_reader :element

  # @private
  def initialize(element, *inc)
    @element = element
    @native  = element.to_n
    @include = inc
  end

  # @!attribute width
  # @return [Integer] the element width
  alias_native :width, :offsetWidth

  def width=(value)
    @element.style[:width] = value
  end

  # @!attribute height
  # @return [Integer] the element height
  alias_native :height, :offsetHeight

  def height=(value)
    @element.style[:height] = value
  end

  # @!attribute client_width
  # @return [Integer] the content-box width of an element
  alias_native :client_width, :clientWidth

  # @!attribute client_height
  # @return [Integer] the content-box height of an element
  alias_native :client_height, :clientHeight
end

end; end; end
