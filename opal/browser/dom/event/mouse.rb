module Browser; module DOM; class Event

class Mouse < UI
  def self.supported?
    not $$[:MouseEvent].nil?
  end

  class Definition < UI::Definition
    def initialize(*)
      super

      %x{
        #@native.view    = #@native.view    || window;
        #@native.screenX = #@native.screenX || 0;
        #@native.screenY = #@native.screenY || 0;
        #@native.clientX = #@native.clientX || 0;
        #@native.clientY = #@native.clientY || 0;

        #@native.button   = #@native.button   || 0;
        #@native.detail   = #@native.detail   || 0;
        #@native.ctrlKey  = #@native.ctrlKey  || false;
        #@native.altKey   = #@native.altKey   || false;
        #@native.shiftKey = #@native.shiftKey || false;
        #@native.metaKey  = #@native.metaKey  || false;
      }
    end

    class Client
      include Native

      def x=(value)
        `#@native.clientX = #{value}`
      end

      def y=(value)
        `#@native.clientY = #{value}`
      end
    end

    class Layer
      include Native

      def x=(value)
        `#@native.layerX = #{value}`
      end

      def y=(value)
        `#@native.layerY = #{value}`
      end
    end

    class Offset
      include Native

      def x=(value)
        `#@native.offsetX = #{value}`
      end

      def y=(value)
        `#@native.offsetY= #{value}`
      end
    end

    class Page
      include Native

      def x=(value)
        `#@native.pageX = #{value}`
      end

      def y=(value)
        `#@native.pageY = #{value}`
      end
    end

    class Screen
      include Native

      def x=(value)
        `#@native.screenX = #{value}`
      end

      def y=(value)
        `#@native.screenY = #{value}`
      end
    end

    class Ancestor
      include Native

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
    Position.new(`#@native.layerX`, `#@native.layerY`) unless `#@native.layerX == null`
  end

  def offset
    Position.new(`#@native.offsetX`, `#@native.offsetY`) unless `#@native.offsetX == null`
  end

  def page
    Position.new(`#@native.pageX`, `#@native.pageY`) unless `#@native.pageX == null`
  end

  def screen
    Position.new(`#@native.screenX`, `#@native.screenY`) unless `#@native.screenX == null`
  end

  def ancestor
    Position.new(`#@native.x`, `#@native.y`) unless `#@native.x == null`
  end

  def x
    screen.x
  end

  def y
    screen.y
  end

  def related
    DOM(`#@native.relatedTarget`) unless `#@native.relatedTarget == null`
  end

  def from
    DOM(`#@native.fromElement`) unless `#@native.fromElement == null`
  end

  def to
    DOM(`#@native.toElement`) unless `#@native.toElement == null`
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
