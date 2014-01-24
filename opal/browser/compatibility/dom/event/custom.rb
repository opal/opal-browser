module Browser; module DOM; class Event; class Custom < Event

if Browser.supports? :event, :constructor
  def self.construct(name, desc)
    `new CustomEvent(name, desc)`
  end
elsif Browser.supports? :event, :create
  def self.construct(name, desc)
    %x{
      var event = document.createEvent("CustomEvent");
          event.initCustomEvent(name, desc.bubbles, desc.cancelable, desc);

      return event;
    }
  end
elsif Browser.supports? :event, :createObject
  def self.construct(name, desc)
    Native(`document.createEventObject()`).merge!(`{
      type:       name,
      bubbles:    desc.bubbles,
      cancelable: desc.cancelable,
      detail:     desc }`).to_n
  end
else
  def self.construct(*)
    raise NotImplementedError
  end
end

end; end; end; end
