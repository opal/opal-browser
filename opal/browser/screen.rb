module Browser

class Screen
  include Native::Base
  include DOM::Event::Target

  target {|value|
    Screen.new(value) if `window.Screen && #{value} instanceof window.Screen`
  }

  alias_native :width
  alias_native :height

  def size
    Size.new(width, height)
  end

  alias_native :x, :top
  alias_native :y, :left

  def position
    Position.new(x, y)
  end

  alias_native :color_depth, :colorDepth
  alias_native :pixel_depth, :pixelDepth

  alias_native :orientation
end

end
