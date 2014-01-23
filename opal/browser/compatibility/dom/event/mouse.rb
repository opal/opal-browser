module Browser; module DOM; class Event; class Mouse < UI

if C.create_event?
  def self.construct(name, desc)
    %x{
      var event = document.createEvent("MouseEvents");
          event.initMouseEvent(name, desc.bubbles, desc.cancelable,
            window, 0,
            desc.screenX, desc.screenY,
            desc.clientX, desc.clientY,
            desc.ctrlKey, desc.altKey, desc.shiftKey, desc.metaKey,
            desc.button, desc.relatedTarget);

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
