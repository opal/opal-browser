module Browser; module DOM; class Event; class Custom < Event

if C.create_event?
  def self.construct(name, desc)
    %x{
      var event = document.createEvent("CustomEvent");
          event.initCustomEvent(name, desc.bubbles, desc.cancelable, desc);

      return event;
    }
  end
elsif C.create_event_object?
  def self.construct(name, desc)
    Native(`document.createEventObject()`).merge!(desc).to_n
  end
else
  def self.construct(*)
    raise NotImplementedError
  end
end unless C.new_event?

end; end; end; end
