module Browser; module DOM; class Event

class Definition
  include Native::Base

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
  def self.convert(value)
    %x{
      if (#{value} == window) {
        return #{$window};
      }
      else if (#{value} instanceof WebSocket) {
        return #{Socket.new(value)};
      }
      else {
        try {
          return #{DOM(value)};
        }
        catch (e) {
          return nil;
        }
      }
    }
  end

  class Callback
    attr_reader :target, :name

    def initialize(target, name, &block)
      %x{
        callback = #{self};
        func     = function(event) {
          event = #{::Browser::DOM::Event.new(`event`, `callback`)};

          #{block.call(`event`, *`event`.arguments)};

          return !#{`event`.stopped?};
        }
      }

      @function = `func`
      @target   = target
      @name     = name
    end

    def off
      target.off(self)
    end

    def to_n
      @function
    end
  end

  def callbacks
    %x{
      if (!#@native.$callbacks) {
        #@native.$callbacks = [];
      }

      return #@native.$callbacks;
    }
  end

  def on(name, &block)
    raise ArgumentError, 'no block has been passed' unless block

    name     = Event.name(name)
    callback = Callback.new(self, name, &block)

    callbacks.push(callback)

    `#@native.addEventListener(#{name}, #{callback.to_n})`

    callback
  end

  def off(what = nil)
    if String === what
      what = Event.name(what)

      callbacks.delete_if {|callback|
        if callback.name == what
          `#@native.removeEventListener(#{name}, #{callback.to_n}, false)`

          true
        end
      }
    elsif Callback === what
      callbacks.delete(what)

      `#@native.removeEventListener(#{what.name}, #{what.to_n}, false)`
    else
      callbacks.each {|callback|
        `#@native.removeEventListener(#{callback.name}, #{callback.to_n}, false)`
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
