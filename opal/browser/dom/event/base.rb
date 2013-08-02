module Browser; module DOM; class Event < Native

class Definition < Native
  def self.new(&block)
    data = super(`{}`)
    block.call(data) if block

    data.to_n
  end

  def bubbles!
    `#@native.bubbles = true`
  end

  def cancelable!
    `#@native.cancelable = true`
  end
end

module Target
  def new_id
    `#@native.$last_id++`
  end

  def callbacks
    return `#@native.$callbacks` if `#@native.$callbacks != null`

    `#@native.$callbacks = #{Hash.new}`
    `#@native.$last_id   = 0`;

    `#@native.$callbacks`
  end

  def on(name, &block)
    raise ArgumentError, 'no block has been passed' unless block

    name     = Event.name(name)
    callback = `function (event) {
      event = #{::Browser::DOM::Event.new(`event`)};

      #{block.call(`event`, *`event`.arguments)};

      return !#{`event`.stopped?};
    }`

    id            = new_id
    callbacks[id] = [name, callback]

    `#@native.addEventListener(#{name}, #{callback})`

    id
  end

  def off(what = nil)
    if String === what
      what = Event.name(what)

      callbacks.delete_if {|_, event|
        name, callback = event

        if name == what
          `#@native.removeEventListener(#{name}, #{callback}, false)`

          true
        end
      }
    elsif Integer === what
      name, callback = callbacks.delete(what)

      `#@native.removeEventListener(#{name}, #{callback}, false)`
    else
      callbacks.each {|id, event|
        name, callback = event

        `#@native.removeEventListener(#{name}, #{callback}, false)`
      }

      callbacks.clear
    end
  end

  def trigger(event, *args, &block)
    if event.is_a? String
      event = Event.create(event, *args, &block)
    end

    `#@native.dispatchEvent(#{event.to_n})`
  end
end

end; end; end
