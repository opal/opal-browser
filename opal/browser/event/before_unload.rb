module Browser; class Event

class BeforeUnload < Event
  def self.supported?
    Browser.supports? 'Event.BeforeUnload'
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new BeforeUnloadEvent(#{name}, #{desc})`
    end
  end if supported?
end

end; end
