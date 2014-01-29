module Browser; class Event

class Composition < UI
  def self.supported?
    Browser.supports? 'Event.Composition'
  end

  class Definition < UI::Definition
    def data=(value)
      `#@native.data = #{value}`
    end

    def locale=(value)
      `#@native.locale = #{value}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new CompositionEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("CompositionEvent");
            event.initCompositionEvent(name, desc.bubbles, desc.cancelable,
              desc.view || window, desc.data, desc.locale);

        return event;
      }
    end
  end if supported?

  alias_native :data
  alias_native :locale

  def start?
    name.downcase == 'compositionstart'
  end

  def update?
    name.downcase == 'compositionupdate'
  end

  def end?
    name.downcase == 'compositionend'
  end
end

end; end
