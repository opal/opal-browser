module Browser; class Event

class DeviceLight < Event
  def self.supported?
    Browser.supports? 'Event.DeviceLight'
  end

  class Definition < Definition
    def value=(value)
      `#@native.value = #{value}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new DeviceLightEvent(#{name}, #{desc})`
    end
  end if supported?

  alias_native :value
end

end; end
