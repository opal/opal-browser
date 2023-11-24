# backtick_javascript: true

module Browser; class Event

class Storage < Event
  handles 'storage'

  def self.supported?
    Browser.supports? 'Event.Storage'
  end

  class Definition < Definition
    alias_native :key=
    alias_native :new=, :newValue=
    alias_native :old=, :oldValue=
    alias_native :area=, :storageArea=
    alias_native :url=
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
