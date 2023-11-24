# backtick_javascript: true

module Browser; class Event

class DeviceOrientation < Event
  handles 'deviceorientation'

  def self.supported?
    Browser.supports? 'Event.DeviceOrientation'
  end

  class Definition < Definition
    alias_native :absolute=
    alias_native :alpha=
    alias_native :beta=
    alias_native :gamma=
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new DeviceOrientationEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("DeviceOrientationEvent");
            event.initDeviceOrientationEvent(name, desc.bubbles, desc.cancelable,
              desc.alpha, desc.beta, desc.gamma, desc.absolute);

        return event;
      }
    end
  end if supported?

  alias_native :absolute
  alias_native :alpha
  alias_native :beta
  alias_native :gamma
end

end; end
