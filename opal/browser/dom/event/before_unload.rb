module Browser; module DOM; class Event

class BeforeUnload < Event
  def self.supported?
    not $$[:BeforeUnloadEvent].nil?
  end

  def self.construct(name, desc)
    `new BeforeUnloadEvent(#{name}, #{desc})`
  end
end

end; end; end
