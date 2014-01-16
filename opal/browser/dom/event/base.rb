module Browser; module DOM

class Event
  include Native

  class Definition
    include Native

    def self.new(&block)
      data = super(`{ bubbles: true, cancelable: true }`)
      block.call(data) if block

      data.to_n
    end

    def bubbles=(value)
      `#@native.bubbles = #{value}`
    end

    def cancelable=(value)
      `#@native.cancelable = #{value}`
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
      return value unless native?(value)

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
      attr_reader :target, :name, :selector

      def initialize(target, name, selector = nil, &block)
        %x{
          #@function = function(event) {
            event = #{::Browser::DOM::Event.new(`event`, `this`, `self`)};

            if (!#{`event`.stopped?}) {
              #{block.call(`event`, *`event`.arguments)};
            }

            return !#{`event`.stopped?};
          }
        }

        @target   = target
        @name     = name
        @selector = selector
      end

      def off
        target.off(self)
      end

      def to_n
        @function
      end
    end

    class Delegate
      def initialize(target, name, pair)
        @target = target
        @name   = name
        @pair   = pair
      end

      def off
        delegate = @target.delegated[@name]
        delegate.last.delete(@pair)

        if delegate.last.empty?
          delegate.first.off
          delegate.delete(@name)
        end
      end
    end

    Delegates = Struct.new(:callback, :handlers)

    def on(name, selector = nil, &block)
      raise ArgumentError, 'no block has been given' unless block

      name = Event.name_for(name)

      if selector
        unless delegate = delegated[name]
          delegate = delegated[name] = Delegates.new

          if %w[blur focus].include?(name)
            delegate.callback = on! name do |e|
              delegate(delegate, e)
            end
          else
            delegate.callback = on name do |e|
              delegate(delegate, e)
            end
          end

          pair = [selector, block]
          delegate.handlers = [pair]

          Delegate.new(self, name, pair)
        else
          pair = [selector, block]
          delegate.handlers << pair

          Delegate.new(self, name, pair)
        end
      else
        callback = Callback.new(self, name, selector, &block)
        callbacks.push(callback)

        `#@native.addEventListener(#{name}, #{callback.to_n})`

        callback
      end
    end

    def on!(name, &block)
      raise ArgumentError, 'no block has been given' unless block

      name = Event.name_for(name)
      callback = Callback.new(self, name, selector, &block)
      callbacks.push(callback)

      `#@native.addEventListener(#{name}, #{callback.to_n}, true)`

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
          what = Event.name_for(what)

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

    # Trigger the event without bubbling.
    def trigger!(event, *args, &block)
      trigger event, *args do |e|
        block.call(e) if block
        e.bubbles = false
      end
    end

  private
    def callbacks
      %x{
        if (!#@native.$callbacks) {
          #@native.$callbacks = [];
        }

        return #@native.$callbacks;
      }
    end

    def delegated
      %x{
        if (!#@native.$delegated) {
          #@native.$delegated = #{{}};
        }

        return #@native.$delegated;
      }
    end

    def delegate(delegates, event, element = event.target)
      return if element.nil? || element == event.element

      delegates.handlers.each {|selector, block|
        if element.matches? selector
          new         = event.dup
          new.element = element

          block.call new, *new.arguments
        end
      }

      delegate(delegates, event, element.parent)
    end
  end
end

end; end
