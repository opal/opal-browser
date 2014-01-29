module Browser; class Event

class Storage < Event
  def self.supported?
    Browser.supports? 'Event.Storage'
  end

  class Definition < Definition
    def key=(value)
      `#@native.key = #{value}`
    end

    def new=(value)
      `#@native.newValue = #{value}`
    end

    def old=(value)
      `#@native.oldValue = #{value}`
    end

    def area=(value)
      `#@native.storageArea = #{value}`
    end

    def url=(value)
      `#@native.url = #{value}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new StorageEvent(#{name}, #{desc})`
    end
  end if supported?

  alias_native :key
  alias_native :new, :newValue
  alias_native :old, :oldValue
  alias_native :area, :storageArea
  alias_native :url
end

end; end
