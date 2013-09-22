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

  def self.create(name, &block)
    new(`new DeviceLightEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :value
end

end; end; end
