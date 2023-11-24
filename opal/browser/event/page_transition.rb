# backtick_javascript: true

module Browser; class Event

class PageTransition < Event
  handles 'pagehide', 'pageshow'

  def self.supported?
    Browser.supports? 'Event.PageTransition'
  end

  class Definition < Definition
    alias_native :persisted=
  end

  if Browser.supports? 'Event.PageTransition'
    def self.construct(name, desc)
      `new PageTransitionEvent(name, desc)`
    end
  end if supported?

  alias_native :persisted?, :persisted
end

end; end
