# backtick_javascript: true

module Browser; class Event

class HashChange < Event
  handles 'hashchange'

  def self.supported?
    Browser.supports? 'Event.HashChange'
  end

  class Definition < Definition
    alias_native :old=, :oldURL=
    alias_native :new=, :newURL=
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new HashChangeEvent(#{name}, #{desc})`
    end
  end if supported?

  alias_native :old, :oldURL
  alias_native :new, :newURL
end

end; end
