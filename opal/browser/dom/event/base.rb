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
  def self.converters
    @converters ||= []
  end

  def self.register(&block)
    converters << block
  end

  def self.convert(value)
    converters.each {|block|
      if result = block.call(value)
        return result
      end
    }

    nil
  end

  def self.included(klass)
    klass.instance_eval {
      def self.target(&block)
        DOM::Event::Target.register(&block)
      end
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
    case what
    when Callback
      callbacks.delete(what)

      `#@native.removeEventListener(#{what.name}, #{what.to_n}, false)`

    when String
      if what.include?(?*) or what.include?(??)
        off(Regexp.new(what.gsub(/\*/, '.*?').gsub(/\?/, ?.)))
      else
        what = Event.name(what)

        callbacks.delete_if {|callback|
          if callback.name == what
            `#@native.removeEventListener(#{callback.name}, #{callback.to_n}, false)`

            true
          end
        }
      end

    when Regexp
      callbacks.delete_if {|callback|
        if callback.name =~ what
          `#@native.removeEventListener(#{callback.name}, #{callback.to_n}, false)`

          true
        end
      }

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
