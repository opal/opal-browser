module Browser; class Event

class HashChange < Event
  def self.supported?
    Browser.supports? 'Event.HashChange'
  end

  class Definition < Definition
    def old=(value)
      `#@native.oldURL = #{value}`
    end

    def new=(value)
      `#@native.newURL = #{value}`
    end
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
