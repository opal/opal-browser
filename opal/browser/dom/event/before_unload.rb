module Browser; module DOM; class Event

class BeforeUnload < Event
  def self.supported?
    not $$[:BeforeUnloadEvent].nil?
  end

  def self.create(name, &block)
    new(`new BeforeUnloadEvent(#{name}, #{Definition.new(&block)})`)
  end
end

end; end; end
