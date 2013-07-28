module Browser; module DOM; class Event < Native

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

  def self.create(name, &block)
    new(`new DeviceMotionEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :acceleration, :acceleration
  alias_native :acceleration_with_gravity, :accelerationIncludingGravity
  alias_native :rotation, :rotationRate
  alias_native :interval, :interval
end

end; end; end
