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

  def self.create(name, &block)
    new(`new DeviceProximityEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :value
  alias_native :min
  alias_native :max
end

end; end; end
