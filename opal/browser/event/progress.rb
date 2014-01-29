module Browser; class Event

class Progress < Event
  def self.supported?
    Browser.supports? 'Event.Progress'
  end

  class Definition < Definition
    def computable=(value)
      `#@native.computableLength = #{value}`
    end

    def loaded=(value)
      `#@native.loaded = #{value}`
    end

    def total=(value)
      `#@native.total = #{value}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new ProgressEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("ProgressEvent");
            event.initProgressEvent(name, desc.bubbles, desc.cancelable,
              desc.computable, desc.loaded, desc.total);

        return event;
      }
    end
  end if supported?

  alias_native :computable?, :computableLength
  alias_native :loaded
  alias_native :total
end

end; end
