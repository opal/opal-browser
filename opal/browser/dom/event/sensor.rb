module Browser; module DOM; class Event

class Sensor < Event
  def self.supported?
    not $$[:SensorEvent].nil?
  end

  def self.create(name, &block)
    new(`new SensorEvent(#{name}, #{Definition.new(&block)})`)
  end
end

end; end; end
