module Browser; class Event

class Sensor < Event
  def self.supported?
    Browser.supports? 'Event.Sensor'
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new SensorEvent(#{name}, #{desc})`
    end
  end if supported?
end

end; end
