module Browser; module DOM; class Event

class DeviceLight < Event
  def self.supported?
    not $$[:DeviceLightEvent].nil?
  end

  class Definition < Definition
    def value=(value)
      `#@native.value = #{value}`
    end
  end

  def self.construct(name, desc)
    `new DeviceLightEvent(#{name}, #{desc})`
  end

  alias_native :value
end

end; end; end
