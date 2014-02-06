module Browser; class Canvas

class StyleObject
  include Native

  attr_reader :context

  def initialize(context)
    @context = context

    super(@context.to_n)
  end
end

class Style < StyleObject
  class Line < StyleObject
    attr_reader :width, :cap, :join, :miter_limit

    def width=(value)
      `#@native.lineWidth = #{@width = value}`
    end

    def cap=(value)
      `#@native.lineCap = #{@cap = value}`
    end

    def join=(value)
      `#@native.lineJoin = #{@join = value}`
    end

    def miter_limit=(value)
      `#@native.miterLimit = #{@miter_limit = value}`
    end
  end

  class Text < StyleObject
    attr_reader :font, :align, :baseline

    def font=(value)
      `#@native.font = #{@font = value}`
    end

    def align=(value)
      `#@native.textAlign = #{@align = value}`
    end

    def baseline=(value)
      `#@native.textBaseline = #{@baseline = value}`
    end
  end

  class Image < StyleObject
    attr_reader :smooth

    alias smooth? smooth

    def smooth!
      `#@native.mozImageSmoothingEnabled = #{@smooth = true}`
    end

    def no_smooth!
      `#@native.mozImageSmoothingEnabled = #{@smooth = false}`
    end
  end

  class Shadow < StyleObject
    attr_reader :offset, :blur, :color

    def offset=(value)
      `#@native.shadowOffsetX = #{value[:x]}`
      `#@native.shadowOffsetY = #{value[:y]}`

      @offset = value
    end

    def blur=(value)
      `#@native.shadowBlur = #{@blur = value}`
    end

    def color=(value)
      `#@native.shadowColor = #{@color = value}`
    end
  end

  attr_reader :line, :text, :image, :shadow, :fill, :stroke, :alpha, :composite_operation

  def initialize(context)
    super(context)

    @line   = Line.new(context)
    @text   = Text.new(context)
    @image  = Image.new(context)
    @shadow = Shadow.new(context)
  end

  def fill=(value)
    `#@native.fillStyle = #{(@fill = value).to_n}`
  end

  def stroke=(value)
    `#@native.strokeStyle = #{(@stroke = value).to_n}`
  end

  def alpha=(value)
    `#@native.globalAlpha = #{@alpha = value}`
  end

  def composite_operation=(value)
    `#@native.globalCompositeOperation = #{@composite_operation = value}`
  end
end

end; end
