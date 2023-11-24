# backtick_javascript: true

require 'buffer'

module Browser; class Event

class Message < Event
  handles 'message'

  def self.supported?
    Browser.supports? 'Event.Message'
  end

  class Definition < Definition
    alias_native :data=
    alias_native :origin=
    alias_native :source=
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
      if (window.ArrayBuffer && #@native.data instanceof ArrayBuffer) {
        return #{Buffer.new(`#@native.data`)};
      }
      else if (window.Blob && #@native.data instanceof Blob) {
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

      if (window.Window && source instanceof window.Window) {
        return #{Window.new(`source`)};
      }
      else {
        return nil;
      }
    }
  end
end

end; end
