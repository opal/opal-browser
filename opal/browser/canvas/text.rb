module Browser; class Canvas

class Text
  include Native

  attr_reader :context

  def initialize(context)
    @context = context

    super(@context.to_n)
  end

  def measure(text)
    `#@native.measureText(text)`
  end

  def fill(text, x = nil, y = nil, max_width = nil)
    x ||= 0
    y ||= 0

    if max_width
      `#@native.fillText(text, x, y, max_width)`
    else
      `#@native.fillText(text, x, y)`
    end

    @context
  end

  def stroke(text, x = nil, y = nil, max_width = nil)
    x ||= 0
    y ||= 0

    if max_width
      `#@native.strokeText(text, x, y, max_width)`
    else
      `#@native.strokeText(text, x, y)`
    end

    @context
  end
end

end; end
