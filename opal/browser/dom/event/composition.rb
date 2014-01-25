module Browser; module DOM; class Event

class Composition < UI
  def self.supported?
    not $$[:CompositionEvent].nil?
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
              window, desc.data, desc.locale);

        return event;
      }
    end
  elsif Browser.supports? 'Event.createObject'
    def self.construct(name, desc)
      Native(`document.createEventObject()`).merge!(desc).to_n
    end
  else
    def self.construct(*)
      raise NotImplementedError
    end
  end


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

end; end; end
