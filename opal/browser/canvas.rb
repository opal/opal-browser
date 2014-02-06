require 'promise'

require 'browser/canvas/style'
require 'browser/canvas/text'
require 'browser/canvas/data'
require 'browser/canvas/gradient'

module Browser

class Canvas
  include Native

  attr_reader :element, :style, :text

  def initialize(*args)
    if DOM::Element === args.first
      element = args.shift

      if DOM::Element::Image === element
        @image   = element
      else
        @element = element
      end
    elsif Canvas === args.first
      @image = args.first
    end

    unless @element
      @element = $document.create_element('canvas')

      if @image
        @element[:width]  = @image.width
        @element[:height] = @image.height
      else
        @element[:width]  = args.shift
        @element[:height] = args.shift
      end
    end

    if @element.node_name != 'CANVAS'
      raise ArgumentError, "the element isn't a <canvas> element"
    end

    super(`#{@element.to_n}.getContext('2d')`)

    @style = Style.new(self)
    @text  = Text.new(self)

    if @image
      draw_image(@image)
    end
  end

  def width
    @element[:width].to_i
  end

  def height
    @element[:height].to_i
  end

  def append_to(parent)
    @element.append_to(parent)
  end

  def load(path)
    promise = Promise.new
    image   = $document.create_element('img')

    image.on :load do
      promise.resolve(image)
    end

    image[:src] = path

    promise
  end

  def data(x = nil, y = nil, width = nil, height = nil)
    x      ||= 0
    y      ||= 0
    width  ||= self.width
    height ||= self.height

    Data.new(self, x, y, width, height)
  end

  def pattern(image, type = :repeat)
    `#@native.createPattern(#{DOM(image).to_n}, type)`
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
    when 4 then quadratic_curve_to(*args)
    when 6 then bezier_curve_to(*args)

    else raise ArgumentError, "don't know where to dispatch"
    end

    self
  end

  def draw_image(image, *args)
    if Canvas === image
      image = image.element
    else
      image = DOM(image)
    end

    if args.first.is_a?(Hash)
      source, destination = args

      `#@native.drawImage(#{image.to_n}, #{source[:x]}, #{source[:y]}, #{source[:width]}, #{source[:height]}, #{destination[:x]}, #{destination[:y]}, #{destination[:width]}, #{destination[:height]})`
    else
      case args.length
      when 0
        `#@native.drawImage(#{image.to_n}, 0, 0)`

      when 2
        `#@native.drawImage(#{image.to_n}, #{args[0]}, #{args[1]})`

      when 4
        `#@native.drawImage(#{image.to_n}, #{args[0]}, #{args[1]}, #{args[2]}, #{args[3]})`
      end
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

      instance_eval(&block)

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

      instance_eval(&block)

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

      instance_eval(&block)

      restore
    else
      `#@native.transform(m11, m12, m21, m22, dx, dy)`
    end

    self
  end

  def path(&block)
    `#@native.beginPath()`

    instance_eval(&block)

    `#@native.closePath()`

    self
  end

  def fill(&block)
    path(&block) if block

    `#@native.fill()`

    self
  end

  def stroke(&block)
    path(&block) if block

    `#@native.stroke()`

    self
  end

  def clip(&block)
    path(&block) if block

    `#@native.clip()`

    self
  end

  def point_in_path?(x, y)
    `#@native.isPointInPath(x, y)`
  end

  def to_data(type = undefined)
    `#{@element.to_n}.toDataUrl(type)`
  end
end

Browser::DOM::Builder.for Canvas do |b, item|
  item.element
end

end
