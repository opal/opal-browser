require 'ostruct'

module Browser; class Event

class Custom < Event
  def self.supported?
    Browser.supports? 'Event.Custom'
  end

  class Definition < Definition
    def method_missing(name, value)
      if name.end_with? ?=
        `#@native[#{name[0 .. -2]}] = value`
      end
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new CustomEvent(name, {
        bubbles:    desc.bubbles,
        cancelable: desc.cancelable,
        detail:     desc })`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("CustomEvent");
            event.initCustomEvent(name, desc.bubbles, desc.cancelable, desc);

        return event;
      }
    end
  elsif Browser.supports? 'Event.createObject'
    def self.construct(name, desc)
      Native(`document.createEventObject()`).merge!(`{
        type:       name,
        bubbles:    desc.bubbles,
        cancelable: desc.cancelable,
        detail:     desc }`).to_n
    end
  else
    def self.construct(name, desc)
      Native(desc).merge!(`{
        type:       name,
        bubbles:    desc.bubbles,
        cancelable: desc.cancelable,
        detail:     desc }`).to_n
    end
  end

  def initialize(event, callback = nil)
    super(event, callback)

    @detail = Hash.new(`#{event}.detail`)
  end

  def method_missing(id, *)
    return @detail[id] if @detail.has_key?(id)

    super
  end
end

end; end
