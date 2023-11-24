# backtick_javascript: true

module Browser; class Event

class DeviceMotion < Event
  handles 'devicemotion'
  
  def self.supported?
    Browser.supports? 'Event.DeviceMotion'
  end

  Acceleration = Struct.new(:x, :y, :z)

  class Definition < Definition
    alias_native :acceleration=
    alias_native :acceleration_with_gravity=, :accelerationIncludingGravity=
    alias_native :rotation=, :rotationRate=
    alias_native :interval=
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new DeviceMotionEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("DeviceMotionEvent");
            event.initDeviceMotionEvent(name, desc.bubbles, desc.cancelable,
              desc.acceleration, desc.accelerationIncludingGravity,
              desc.rotationRate, desc.interval);

        return event;
      }
    end
  end if supported?

  alias_native :acceleration
  alias_native :acceleration_with_gravity, :accelerationIncludingGravity
  alias_native :rotation, :rotationRate
  alias_native :interval
end

end; end
