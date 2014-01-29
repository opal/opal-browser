module Browser; class Event

# TODO: handle transfers
class Drag < Event
  def self.supported?
    Browser.supports? 'Event.Drag'
  end

  class Definition < Definition
    class Client
      include Native

      def x=(value)
        `#@native.clientX = #{value}`
      end

      def y=(value)
        `#@native.clientY = #{value}`
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

    def screen
      Screen.new(@native)
    end

    def related=(elem)
      `#@native.relatedTarget = #{Native.convert(elem)}`
    end

    def transfer=(value)
      `#@native.dataTransfer = #{Native.convert(elem)}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new DragEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("DragEvent");
            event.initDragEvent(name, desc.bubbles, desc.cancelable,
              desc.view || window, 0,
              desc.screenX || 0, desc.screenY || 0,
              desc.clientX || 0, desc.clientY || 0,
              desc.ctrlKey, desc.altKey, desc.shiftKey, desc.metaKey,
              desc.button || 0, desc.relatedTarget, desc.dataTransfer);

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

  def screen
    Position.new(`#@native.screenX`, `#@native.screenY`) if defined?(`#@native.screenX`)
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

  # @see https://developer.mozilla.org/en-US/docs/Web/API/DataTransfer
  def transfer
    raise NotImplementedError
  end
end

end; end
