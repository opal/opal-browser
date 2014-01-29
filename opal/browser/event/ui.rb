module Browser; class Event

class UI < Event
  def self.supported?
    Browser.supports? 'Event.UI'
  end

  class Definition < Definition
    def detail=(value)
      `#@native.detail = #{value}`
    end

    def view=(value)
      `#@native.view = #{value}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new UIEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("UIEvent");
            event.initUIEvent(name, desc.bubbles, desc.cancelable,
              desc.view || window, desc.detail || 0);

        return event;
      }
    end
  end if supported?

  alias_native :detail
  alias_native :view
end

end; end
