# backtick_javascript: true

module Browser; class Event

class PopState < Event
  handles 'popstate'

  def self.supported?
    Browser.supports? 'Event.PopState'
  end

  class Definition < Definition
    def state=(value)
      alias_native :state=
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new PopStateEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent('PopStateEvent');
            event.initPopStateEvent(name, desc.bubbles, desc.cancelable,
              desc.state);

        return event;
      }
    end
  end if supported?

  alias_native :state
end

end; end
