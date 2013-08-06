module Browser; module DOM; class Event

class Touch < Event
  def self.supported?
    not $$[:TouchEvent].nil?
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

  def self.create(name, &block)
    new(`new TouchEvent(#{name}, #{Definition.new(&block)})`)
  end

  def alt?
    `#@native.altKey`
  end

  def ctrl?
    `#@native.ctrlKey`
  end

  def meta?
    `#@native.metaKey`
  end

  def shift?
    `#@native.shiftKey`
  end

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

end; end; end
