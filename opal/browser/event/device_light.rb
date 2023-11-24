# backtick_javascript: true

module Browser; class Event

class DeviceLight < Event
  handles 'devicelight'

  def self.supported?
    Browser.supports? 'Event.DeviceLight'
  end

  class Definition < Definition
    alias_native :value
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new DeviceLightEvent(#{name}, #{desc})`
    end
  end if supported?

  alias_native :value
end

end; end
