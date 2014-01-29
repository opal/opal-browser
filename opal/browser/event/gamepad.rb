module Browser; class Event

class Gamepad < Event
  def self.supported?
    Browser.supports? 'Event.Gamepad'
  end

  class Definition < Definition
    def id=(value)
      `#@native.id = #{value}`
    end

    def index=(value)
      `#@native.index = #{value}`
    end

    def at=(value)
      `#@native.timestamp = #{value}`
    end

    def axes=(value)
      `#@native.axes = #{value}`
    end

    def buttons=(value)
      `#@native.buttons = #{value}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new GamepadEvent(#{name}, {
        bubbles:    desc.bubbles,
        cancelable: desc.cancelable,
        gamepad:    desc })`
    end
  end if supported?

  def id
    `#@native.gamepad.id`
  end

  def index
    `#@native.gamepad.index`
  end

  def at
    `#@native.gamepad.timestamp`
  end

  def axes
    `#@native.gamepad.axes`
  end

  def buttons
    `#@native.gamepad.buttons`
  end
end

end; end
