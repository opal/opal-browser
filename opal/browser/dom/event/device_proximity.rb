module Browser; module DOM; class Event

class DeviceProximity < Event
  def self.supported?
    not $$[:DeviceProximityEvent].nil?
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

  def self.construct(name, desc)
    `new DeviceProximityEvent(#{name}, #{desc})`
  end

  alias_native :value
  alias_native :min
  alias_native :max
end

end; end; end
