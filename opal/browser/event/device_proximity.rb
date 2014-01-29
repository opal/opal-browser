module Browser; class Event

class DeviceProximity < Event
  def self.supported?
    Browser.supports? 'Event.DeviceProximity'
  end

  class Definition < Definition
    def value=(value)
      `#@native.value = #{value}`
    end

    def min=(value)
      `#@native.min = #{value}`
    end

    def max=(value)
      `#@native.max = #{value}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new DeviceProximityEvent(#{name}, #{desc})`
    end
  end if supported?

  alias_native :value
  alias_native :min
  alias_native :max
end

end; end
