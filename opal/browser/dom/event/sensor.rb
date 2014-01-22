module Browser; module DOM; class Event

class Sensor < Event
  def self.supported?
    not $$[:SensorEvent].nil?
  end

  def self.construct(name, desc)
    `new SensorEvent(#{name}, #{desc})`
  end
end

end; end; end
