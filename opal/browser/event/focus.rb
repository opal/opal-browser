# backtick_javascript: true

module Browser; class Event

class Focus < UI
  handles 'blur', 'focus', 'focusin', 'focusout'

  def self.supported?
    Browser.supports? 'Event.Focus'
  end

  class Definition < UI::Definition
    alias_native :view=
    alias_native :related=, :relatedTarget
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
