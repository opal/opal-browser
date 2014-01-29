module Browser; class Event

class Focus < UI
  def self.supported?
    Browser.supports? 'Event.Focus'
  end

  class Definition < UI::Definition
    def view=(value)
      `#@native.view = #{Native.convert(value)}`
    end

    def related=(elem)
      `#@native.relatedTarget = #{Native.convert(elem)}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new FocusEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("FocusEvent");
            event.initFocusEvent(name, desc.bubbles, desc.cancelable,
              desc.view || window, 0, desc.relatedTarget);

        return event;
      }
    end
  end if supported?

  def related
    DOM(`#@native.relatedTarget`)
  end
end

end; end
