module Browser; class Event

class PageTransition < Event
  def self.supported?
    Browser.supports? 'Event.PageTransition'
  end

  class Definition < Definition
    def persisted=(value)
      `#@native.persisted = #{value}`
    end
  end

  if Browser.supports? 'Event.PageTransition'
    def self.construct(name, desc)
      `new PageTransitionEvent(name, desc)`
    end
  end if supported?

  alias_native :persisted?, :persisted
end

end; end
