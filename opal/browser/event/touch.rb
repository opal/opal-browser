module Browser; class Event

class Touch < Event
  def self.supported?
    Browser.supports? 'Event.Touch'
  end

  class Definition < Definition
    def alt!
      `#@native.altKey = true`
    end

    def ctrl!
      `#@native.ctrlKey = true`
    end

    def meta!
      `#@native.metaKey = true`
    end

    def shift!
      `#@native.shiftKey = true`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new TouchEvent(#{name}, #{desc})`
    end
  end if supported?

  alias_native :alt?, :altKey
  alias_native :ctrl?, :ctrlKey
  alias_native :meta?, :metaKey
  alias_native :shift?, :shiftKey

  # TODO: implement touches and targetTouches

  def cancel?
    name.downcase == 'touchcancel'
  end

  def end?
    name.downcase == 'touchend'
  end

  def leave?
    name.downcase == 'touchleave'
  end

  def move?
    name.downcase == 'touchmove'
  end

  def start?
    name.downcase == 'touchstart'
  end
end

end; end
