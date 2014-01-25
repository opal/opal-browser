module Browser; module DOM; class Event

class DeviceMotion < Event
  def self.supported?
    not $$[:DeviceMotionEvent].nil?
  end

  Acceleration = Struct.new(:x, :y, :z)

  class Definition < Definition
    def acceleration=(value)
      `#@native.acceleration = #{value.to_n}`
    end

    def acceleration_with_gravity=(value)
      `#@native.accelerationIncludingGravity = #{value.to_n}`
    end

    def rotation=(value)
      `#@native.rotationRate = #{value}`
    end

    def interval=(value)
      `#@native.interval = #{value}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new DeviceMotionEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("DeviceMotionEvent");
            event.initDeviceMotionEvent(name, desc.bubbles, desc.cancelable,
              desc.acceleration, desc.accelerationIncludingGravity,
              desc.rotationRate, desc.interval);

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


  alias_native :acceleration
  alias_native :acceleration_with_gravity, :accelerationIncludingGravity
  alias_native :rotation, :rotationRate
  alias_native :interval
end

end; end; end
