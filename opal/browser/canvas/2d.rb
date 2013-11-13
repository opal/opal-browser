module Browser; class Canvas

Context.define '2d' do
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

  class Text
    attr_reader :context

    def initialize(context)
      @context = context
    end

    def measure(text)
      `#@native.measureText(text)`
    end

    def fill(text, x = nil, y = nil, max_width = undefined)
      x ||= 0
      y ||= 0

      `#@native.fillText(text, x, y, max_width)`

      @context
    end

    def stroke(text, x = nil, y = nil, max_width = undefined)
      x ||= 0
      y ||= 0

      `#@native.strokeText(text, x, y, max_width)`

      @context
    end
  end

  class Data
    def self.create(context, width, height)
      data = allocate

      data.instance_eval {
        @context = context
        @x       = 0
        @y       = 0
        @width   = width
        @height  = height

        @native = `#{context.to_n}.createImageData(width, height)`
      }

      data
    end

    include Native

    attr_reader :x, :y, :width, :height

    def initialize(context, x, y, width, height)
      @context = context
      @x       = x
      @y       = y
      @width   = width
      @height  = height

      super(`#{@context.to_n}.getImageData(x, y, width, height)`)
    end

    def length
      `#@native.length`
    end

    def [](index)
      `#@native.data[index]`
    end

    def []=(index, value)
      `#@native.data[index] = value`
    end

    def save(x = nil, y = nil)
      x ||= 0
      y ||= 0

      `#{@context.to_n}.putImageData(#@native, x, y)`
    end

    def save_to(context, x = nil, y = nil)
      x ||= 0
      y ||= 0

      `#{context.to_n}.putImageData(#@native, x, y)`
    end

    alias size length
  end

  class Gradient
    include Native

    attr_reader :context

    def initialize(context, *args, &block)
      @context = context

      super(case args.length
        when 4 then `#{@context.to_n}.createLinearGradient.apply(self, args)`
        when 6 then `#{@context.to_n}.createRadialGradient.apply(self, args)`
        else raise ArgumentError, "don't know where to dispatch"
      end)

      instance_eval(&block)
    end

    def add(position, color)
      `#{@context.to_n}.addColorStop(position, color)`

      self
    end
  end

  attr_reader :style, :text

  def initialize(element)
    super(element)

    @native = `#@element.getContext('2d')`

    @style = Style.new(self)
    @text  = Text.new(self)
  end

  def data(x = nil, y = nil, width = nil, height = nil)
    x      ||= 0
    y      ||= 0
    width  ||= self.width
    height ||= self.height

    Data.new(self, x, y, width, height)
  end

  def pattern(image, type = :repeat)
    `#@native.createPattern(#{Element(image).to_n}, type)`
  end

  def gradient(*args, &block)
    Gradient.new(self, *args, &block)
  end

  def clear(x = nil, y = nil, width = nil, height = nil)
    x      ||= 0
    y      ||= 0
    width  ||= self.width
    height ||= self.height

    `#@native.clearRect(x, y, width, height)`
  end

  def begin
    `#@native.beginPath()`

    self
  end

  def close
    `#@native.closePath()`

    self
  end

  def save
    `#@native.save()`

    self
  end

  def restore
    `#@native.restore()`

    self
  end

  def move_to(x, y)
    `#@native.moveTo(x, y)`

    self
  end

  alias move move_to

  def line_to(x, y)
    `#@native.lineTo(x, y)`

    self
  end

  def line(x1, y1, x2, y2)
    move_to x1, y1
    line_to x2, y2
  end

  def rect(x, y, width, height)
    `#@native.rect(x, y, width, height)`

    self
  end

  def arc(x, y, radius, angle, clockwise = false)
    `#@native.arc(x, y, radius, #{angle[:start]}, #{angle[:end]}, !clockwise)`

    self
  end

  def quadratic_curve_to(cp1x, cp1y, x, y)
    `#@native.quadraticCurveTo(cp1x, cp1y, x, y)`

    self
  end

  def bezier_curve_to(cp1x, cp1y, cp2x, cp2y, x, y)
    `#@native.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y)`

    self
  end

  def curve_to(*args)
    case args.length
    when 4 then quadratic_curve_to *args
    when 6 then bezier_curve_to *args
    else raise ArgumentError, "don't know where to dispatch"
    end

    self
  end

  def draw_image(*args)
    image = Element(args.shift)

    if args.first.is_a?(Hash)
      source, destination = args

      `#@native.drawImage(#{image.to_n}, #{source[:x]}, #{source[:y]}, #{source[:width]}, #{source[:height]}, #{destination[:x]}, #{destination[:y]}, #{destination[:width]}, #{destination[:height]})`
    else
      x, y, width, height = args

      `#@native.drawImage(#{image.to_n}, x, y, #{width || `undefined`}, #{height || `undefined`})`
    end

    self
  end

  def translate(x, y, &block)
    if block
      save

      `#@native.translate(x, y)`

      instance_eval(&block)

      restore
    else
      `#@native.translate(x, y)`
    end

    self
  end

  def rotate(angle, &block)
    if block
      save

      `#@native.rotate(angle)`

      instance_eval &block

      restore
    else
      `#@native.rotate(angle)`
    end

    self
  end

  def scale(x, y, &block)
    if block
      save

      `#@native.scale(x, y)`

      instance_eval &block

      restore
    else
      `#@native.scale(x, y)`
    end

    self
  end

  def transform(m11, m12, m21, m22, dx, dy, &block)
    if block
      save

      `#@native.transform(m11, m12, m21, m22, dx, dy)`

      instance_eval &block

      restore
    else
      `#@native.transform(m11, m12, m21, m22, dx, dy)`
    end

    self
  end

  def path(&block)
    `#@native.beginPath()`

    instance_eval &block

    `#@native.closePath()`

    self
  end

  def fill(&block)
    path &block if block

    `#@native.fill()`

    self
  end

  def stroke(&block)
    path &block if block

    `#@native.stroke()`

    self
  end

  def clip(&block)
    path &block if block

    `#@native.clip()`

    self
  end
end

end; end
