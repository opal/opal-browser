module Browser; module DOM; class Event; class Composition < UI

if Browser.supports? :event, :constructor
  def self.construct(name, desc)
    `new CompositionEvent(#{name}, #{desc})`
  end
elsif Browser.supports? :event, :create
  def self.construct(name, desc)
    %x{
      var event = document.createEvent("CompositionEvent");
          event.initCompositionEvent(name, desc.bubbles, desc.cancelable,
            window, desc.data, desc.locale);

      return event;
    }
  end
elsif Browser.supports? :event, :createObject
  def self.construct(name, desc)
    Native(`document.createEventObject()`).merge!(desc).to_n
  end
else
  def self.construct(*)
    raise NotImplementedError
  end
end

end; end; end; end
