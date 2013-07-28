module Browser; module DOM; class Event < Native

class Mouse < UI
  def self.supported?
    not $$[:MouseEvent].nil?
  end

  class Definition < UI::Definition
    class Client < Native
      def x=(value)
        `#@native.clientX = #{value}`
      end

      def y=(value)
        `#@native.clientY = #{value}`
      end
    end

    class Layer < Native
      def x=(value)
        `#@native.layerX = #{value}`
      end

      def y=(value)
        `#@native.layerY = #{value}`
      end
    end

    class Offset < Native
      def x=(value)
        `#@native.offsetX = #{value}`
      end

      def y=(value)
        `#@native.offsetY= #{value}`
      end
    end

    class Page < Native
      def x=(value)
        `#@native.pageX = #{value}`
      end

      def y=(value)
        `#@native.pageY = #{value}`
      end
    end

    class Screen < Native
      def x=(value)
        `#@native.screenX = #{value}`
      end

      def y=(value)
        `#@native.screenY = #{value}`
      end
    end

    class Ancestor < Native
      def x=(value)
        `#@native.x = #{value}`
      end

      def y=(value)
        `#@native.y = #{value}`
      end
    end

    def x=(value)
      `#@native.screenX = #{value}`
    end

    def y=(value)
      `#@native.screenY = #{value}`
    end

    def alt!
      `#@native.altKey = true`
    end

    def ctrl!
      `#@native.ctrlKey = true`
    end

    def meta!
      `#@native.metaKey = true`
    end

    def button=(value)
      `#@native.button = #{value}`
    end

    def client
      Client.new(@native)
    end

    def layer
      Layer.new(@native)
    end

    def offset
      Offset.new(@native)
    end

    def page
      Page.new(@native)
    end

    def screen
      Screen.new(@native)
    end

    def ancestor
      Ancestor.new(@native)
    end

    def related=(elem)
      `#@native.relatedTarget = #{Native.try_convert(elem)}`
    end

    def from=(elem)
      `#@native.fromElement = #{Native.try_convert(elem)}`
    end

    def to=(elem)
      `#@native.toElement = #{Native.try_convert(elem)}`
    end
  end

  def self.create(name, &block)
    new(`new MouseEvent(#{name}, #{Definition.new(&block)})`)
  end

  Position = Struct.new(:x, :y)

  def alt?
    `#@native.altKey`
  end

  def ctrl?
    `#@native.ctrlKey`
  end

  def meta?
    `#@native.metaKey`
  end

  def shift?
    `#@native.shiftKey`
  end

  def button
    `#@native.button`
  end

  def client
    Position.new(`#@native.clientX`, `#@native.clientY`)
  end

  def layer
    Position.new(`#@native.layerX`, `#@native.layerY`) if defined?(`#@native.layerX`)
  end

  def offset
    Position.new(`#@native.offsetX`, `#@native.offsetY`) if defined?(`#@native.offsetX`)
  end

  def page
    Position.new(`#@native.pageX`, `#@native.pageY`) if defined?(`#@native.pageX`)
  end

  def screen
    Position.new(`#@native.screenX`, `#@native.screenY`) if defined?(`#@native.screenX`)
  end

  def ancestor
    Position.new(`#@native.x`, `#@native.y`) if defined?(`#@native.x`)
  end

  def x
    screen.x
  end

  def y
    screen.y
  end

  def related
    DOM(`#@native.relatedTarget`)
  end

  def from
    DOM(`#@native.fromElement`)
  end

  def to
    DOM(`#@native.toElement`)
  end

  def click?
    name.downcase == 'click'
  end

  def double_click?
    name.downcase == 'dblclick'
  end

  def down?
    name.downcase == 'mousedown'
  end

  def enter?
    name.downcase == 'mouseenter'
  end

  def leave?
    name.downcase == 'mouseleave'
  end

  def move?
    name.downcase == 'mousemove'
  end

  def out?
    name.downcase == 'mouseout'
  end

  def over?
    name.downcase == 'mouseover'
  end

  def up?
    name.downcase == 'mouseup'
  end

  def show?
    name.downcase == 'show'
  end
end

end; end; end
