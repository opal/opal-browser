module Browser; module DOM; class Event; class DeviceMotion < Event

if Browser.supports? :event, :constructor
  def self.construct(name, desc)
    `new DeviceMotionEvent(#{name}, #{desc})`
  end
elsif Browser.supports? :event, :create
  def self.construct(name, desc)
    %x{
      var event = document.createEvent("DeviceMotionEvent");
          event.initDeviceMotionEvent(name, desc.bubbles, desc.cancelable,
            desc.acceleration, desc.accelerationIncludingGravity,
            desc.rotationRate, desc.interval);

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
