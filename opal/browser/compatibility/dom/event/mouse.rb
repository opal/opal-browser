module Browser; module DOM; class Event; class Mouse < UI

if Browser.supports? :event, :constructor
  def self.construct(name, desc)
    `new MouseEvent(#{name}, #{desc})`
  end
elsif Browser.supports? :event, :create
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
