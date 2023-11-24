# backtick_javascript: true

module Browser; class Event

class DeviceProximity < Event
  handles 'deviceproximity'

  def self.supported?
    Browser.supports? 'Event.DeviceProximity'
  end

  class Definition < Definition
    alias_native :value=
    alias_native :min=
    alias_native :max=
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
