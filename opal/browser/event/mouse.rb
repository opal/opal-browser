# backtick_javascript: true

module Browser; class Event

class Mouse < UI
  handles 'click', 'contextmenu', 'dblclick', 'mousedown', 'mouseenter',
          'mouseleave', 'mousemove', 'mouseout', 'mouseover', 'mouseup',
          'show'

  def self.supported?
    not $$[:MouseEvent].nil?
  end

  class Definition < UI::Definition
    class Client
      include Native::Wrapper

      alias_native :x=, :clientX=
      alias_native :y=, :clientY=
    end

    class Layer
      include Native::Wrapper

      alias_native :x=, :layerX=
      alias_native :y=, :layerY=
    end

    class Offset
      include Native::Wrapper

      alias_native :x=, :offsetX=
      alias_native :y=, :offsetY=
    end

    class Page
      include Native::Wrapper

      alias_native :x=, :pageX=
      alias_native :y=, :pageY=
    end

    class Screen
      include Native::Wrapper

      alias_native :x=, :screenX=
      alias_native :y=, :screenY=
    end

    class Ancestor
      include Native::Wrapper

      alias_native :x=
      alias_native :y=
    end

    alias_native :x=, :screenX=
    alias_native :y=, :screenY=
    alias_native :button=
    alias_native :related=, :relatedTarget=
    alias_native :from=, :fromElement=
    alias_native :to=, :toElement=

    def alt!
      `#@native.altKey = true`
    end

    def ctrl!
      `#@native.ctrlKey = true`
    end

    def meta!
      `#@native.metaKey = true`
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
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new MouseEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("MouseEvent");
            event.initMouseEvent(name, desc.bubbles, desc.cancelable,
              desc.view || window, desc.detail || 0,
              desc.screenX || 0, desc.screenY || 0,
              desc.clientX || 0, desc.clientY || 0,
              desc.ctrlKey || false, desc.altKey || false,
              desc.shiftKey || false, desc.metaKey || false,
              desc.button || 0, desc.relatedTarget || null);

        return event;
      }
    end
  end if supported?

  alias_native :alt?, :altKey
  alias_native :ctrl?, :ctrlKey
  alias_native :meta?, :metaKey
  alias_native :shift?, :shiftKey
  alias_native :button

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

end; end
