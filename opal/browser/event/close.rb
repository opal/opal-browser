module Browser; class Event

class Close < Event
  def self.supported?
    Browser.supports? 'Event.Close'
  end

  class Definition < Definition
    def code=(value)
      `#@native.code = #{value}`
    end

    def reason=(value)
      `#@native.reason = #{value}`
    end

    def clean!(value)
      `#@native.wasClean = true`
    end

    def not_clean!(value)
      `#@native.wasClean = false`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new CloseEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("CloseEvent");
            event.initCloseEvent(name, desc.bubbles, desc.cancelable,
              desc.wasClean, desc.code, desc.reason);

        return event;
      }
    end
  end if supported?

  alias_native :code
  alias_native :reason
  alias_native :clean?, :wasClean
end

end; end
