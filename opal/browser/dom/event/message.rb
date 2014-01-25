require 'buffer'

module Browser; module DOM; class Event

class Message < Event
  def self.supported?
    Browser.supports? 'Event.Message'
  end

  class Definition < Definition
    def data=(value)
      `#@native.data = value`
    end

    def origin=(value)
      `#@native.origin = value`
    end

    def source=(value)
      `#@native.source = #{Native.convert(value)}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new MessageEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("MessageEvent");
            event.initMessageEvent(name, desc.bubbles, desc.cancelable,
              desc.data, desc.origin, "", desc.source || window);

        return event;
      }
    end
  end if supported?

  def data
    %x{
      if (#@native.data instanceof ArrayBuffer) {
        return #{Buffer.new(`#@native.data`)};
      }
      else if (#@native.data instanceof Blob) {
        return #{Blob.new(`#@native.data`)};
      }
      else {
        return #@native.data;
      }
    }
  end

  alias_native :origin

  def source
    %x{
      var source = #@native.source;

      if (source instanceof window.Window) {
        return #{Window.new(`source`)};
      }
      else {
        return nil;
      }
    }
  end
end

end; end; end
