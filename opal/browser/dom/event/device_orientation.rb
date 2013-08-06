module Browser; module DOM; class Event

class DeviceOrientation < Event
  def self.supported?
    not $$[:DeviceOrientationEvent].nil?
  end

  class Definition < Definition
    def absolute=(value)
      `#@native.absolute = #{value}`
    end

    def alpha=(value)
      `#@native.alpha = #{value}`
    end

    def beta=(value)
      `#@native.beta = #{value}`
    end

    def gamma=(value)
      `#@native.gamma = #{value}`
    end
  end

  def self.create(name, &block)
    new(`new DeviceOrientationEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :absolute, :absolute
  alias_native :alpha, :alpha
  alias_native :beta, :beta
  alias_native :gamma, :gamma
end

end; end; end
