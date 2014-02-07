module Browser

class Event
  include Native

  # @see https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Creating_and_triggering_events
  class Definition
    include Native

    # @private
    def self.new(&block)
      data = super(`{ bubbles: true, cancelable: true }`)
      block.call(data) if block

      data.to_n
    end

    # Set the event as bubbling.
    def bubbles=(value)
      `#@native.bubbles = #{value}`
    end

    # Set the event as cancelable.
    def cancelable=(value)
      `#@native.cancelable = #{value}`
    end
  end

  module Target
    # @private
    def self.converters
      @converters ||= []
    end

    # @private
    def self.register(&block)
      converters << block
    end

    # @private
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
          Event::Target.register(&block)
        end
      }
    end

    class Callback
      attr_reader :target, :name, :selector

      # @private
      def initialize(target, name, selector = nil, &block)
        @target   = target
        @name     = name
        @selector = selector
        @block    = block
      end

      # Call the callback with the given event.
      #
      # @param event [native] the native event object
      def call(event)
        to_proc.call(event)
      end

      # Get the native function linked to the callback.
      def to_proc
        @proc ||= -> event {
          %x{
            if (!event.currentTarget) {
              event.currentTarget = self.target.native;
            }
          }

          event = Event.new(event, self)

          unless event.stopped?
            @block.call(event, *event.arguments)
          end

          !event.prevented?
        }
      end

      # @!attribute [r] event
      # @return [Class] the class for the event
      def event
        Event.class_for(@name)
      end

      # Stop listening for the event linked to the callback.
      def off
        target.off(self)
      end
    end

    class Delegate
      def initialize(target, name, pair)
        @target = target
        @name   = name
        @pair   = pair
      end

      # Stop listening for the event linked to the delegate.
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

    # @overload on(name, &block)
    #
    #   Start listening for an event on the target.
    #
    #   @param name [String] the event name
    #
    #   @yieldparam event [Event] the event
    #
    #   @return [Callback]
    #
    # @overload on(name, selector, &block)
    #
    #   Start listening for an event on the target children.
    #
    #   @param name [String] the event name
    #   @param selector [String] the CSS selector to trigger the event on
    #
    #   @yieldparam event [Event] the event
    #
    #   @return [Delegate]
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

        attach(callback)
      end
    end

    # Start listening for an event in the capturing phase.
    #
    # @param name [String] the event name
    #
    # @yieldparam event [Event] the event
    #
    # @return [Callback]
    def on!(name, &block)
      raise ArgumentError, 'no block has been given' unless block

      name     = Event.name_for(name)
      callback = Callback.new(self, name, &block)
      callbacks.push(callback)

      attach!(callback)
    end

    if Browser.supports? 'Event.addListener'
      def attach(callback)
        `#@native.addEventListener(#{callback.name}, #{callback.to_proc})`

        callback
      end

      def attach!(callback)
        `#@native.addEventListener(#{callback.name}, #{callback.to_proc}, true)`

        callback
      end
    elsif Browser.supports? 'Event.attach'
      def attach(callback)
        if callback.event == Custom
          %x{
            if (!#@native.$custom) {
              #@native.$custom = function(event) {
                for (var i = 0, length = #@native.$callbacks.length; i < length; i++) {
                  var callback = #@native.$callbacks[i];

                  if (#{`callback`.event == Custom}) {
                    event.type = callback.name;

                    #{`callback`.call(`event`)};
                  }
                }
              };

              #@native.attachEvent("ondataavailable", #@native.$custom);
            }
          }
        else
          `#@native.attachEvent("on" + #{callback.name}, #{callback.to_proc})`
        end

        callback
      end

      def attach!(callback)
        case callback.name
        when :blur
          `#@native.attachEvent("onfocusout", #{callback.to_proc})`

        when :focus
          `#@native.attachEvent("onfocusin", #{callback.to_proc})`

        else
          warn "attach: capture doesn't work on this browser"
          attach(callback)
        end

        callback
      end
    else
      # @todo implement polyfill
      # @private
      def attach(*)
        raise NotImplementedError
      end

      # @todo implement polyfill
      # @private
      def attach!(*)
        raise NotImplementedError
      end
    end

    # @overload off()
    #   Stop listening for any event.
    #
    # @overload off(what)
    #   Stop listening for an event.
    #
    #   @param what [Callback, String, Regexp] what to stop listening for
    def off(what = nil)
      case what
      when Callback
        callbacks.delete(what)
        detach(what)

      when String
        if what.include?(?*) or what.include?(??)
          off(Regexp.new(what.gsub(/\*/, '.*?').gsub(/\?/, ?.)))
        else
          what = Event.name_for(what)

          callbacks.delete_if {|callback|
            if callback.name == what
              detach(callback)

              true
            end
          }
        end

      when Regexp
        callbacks.delete_if {|callback|
          if callback.name =~ what
            detach(callback)

            true
          end
        }

      else
        callbacks.each {|callback|
          detach(callback)
        }

        callbacks.clear
      end
    end

    if Browser.supports? 'Event.removeListener'
      def detach(callback)
        `#@native.removeEventListener(#{callback.name}, #{callback.to_proc}, false)`
      end
    elsif Browser.supports? 'Event.detach'
      def detach(callback)
        if callback.event == Custom
          if callbacks.none? { |c| c.event == Custom }
            %x{
              #@native.detachEvent("ondataavailable", #@native.$custom);

              delete #@native.$custom;
            }
          end
        else
          `#@native.detachEvent("on" + #{callback.name}, #{callback.to_proc})`
        end
      end
    else
      # @todo implement internal handler thing
      # @private
      def detach(callback)
        raise NotImplementedError
      end
    end

    # Trigger an event on the target.
    #
    # @param name [String] the event name
    # @param args [Array] optional arguments to the event callback
    #
    # @yieldparam definition [Definition] definition to customize the event
    def trigger(event, *args, &block)
      if event.is_a? String
        event = Event.create(event, *args, &block)
      end

      dispatch(event)
    end

    # Trigger an event on the target without bubbling.
    #
    # @param name [String] the event name
    # @param args [Array] optional arguments to the event callback
    #
    # @yieldparam definition [Definition] definition to customize the event
    def trigger!(event, *args, &block)
      trigger event, *args do |e|
        block.call(e) if block
        e.bubbles = false
      end
    end

    if Browser.supports? 'Event.dispatch'
      def dispatch(event)
        `#@native.dispatchEvent(#{event.to_n})`
      end
    elsif Browser.supports? 'Event.fire'
      def dispatch(event)
        if Custom === event
          `#@native.fireEvent("ondataavailable", #{event.to_n})`
        else
          `#@native.fireEvent("on" + #{event.name}, #{event.to_n})`
        end
      end
    else
      # @todo implement polyfill
      # @private
      def dispatch(*)
        raise NotImplementedError
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
      return if element.nil? || element == event.on

      delegates.handlers.each {|selector, block|
        if element =~ selector
          new    = event.dup
          new.on = element

          block.call new, *new.arguments
        end
      }

      delegate(delegates, event, element.parent)
    end
  end
end

end
