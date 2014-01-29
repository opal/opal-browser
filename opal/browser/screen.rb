module Browser

# Representation of the screen the window is being rendered on.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/Window.screen
class Screen
  include Native
  include Event::Target

  target {|value|
    Screen.new(value) if Native.is_a?(value, `window.Screen`)
  }

  Depth = Struct.new(:color, :pixel)

  # @!attribute [r] width
  # @return [Integer] the width of the screen in pixels
  alias_native :width

  # @!attribute [r] height
  # @return [Integer] the height of the screen in pixels
  alias_native :height

  # @!attribute [r] size
  # @return [Size] the size in pixels
  def size
    Size.new(width, height)
  end

  # @!attribute [r] x
  # @return [Integer] the offset from the top left corner of the screen in
  #                   pixels
  alias_native :x, :top

  # @!attribute [r] y
  # @return [Integer] the offset from the top left corner of the screen in
  #                   pixels
  alias_native :y, :left

  # @!attribute [r] position
  # @return [Position] the offset from the top left corner of the screen in
  #                    pixels
  def position
    Position.new(x, y)
  end

  # @!attribute [r] depth
  # @return [Depth] the screen depth
  def depth
    Depth.new(`#@native.colorDepth`, `#@native.pixelDepth`)
  end

  # @!attribute [r] orientation
  # @return [String] the orientation of the screen
  alias_native :orientation
end

class Window
  # @!attribute [r] screen
  # @return [Screen] the screen for the window
  def screen
    Screen.new(`#@native.screen`)
  end
end

end
