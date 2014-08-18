require 'promise'

module Browser

# Class to easily create and dispatch an immediate call.
#
# Immediate calls are deferred function calls that happen as soon as they can
# be scheduled.
#
# Compatibility
# -------------
# The compatibility layer will try various implementations in the following
# order.
#
# + [setImmediate](https://developer.mozilla.org/en-US/docs/Web/API/Window.setImmediate)
# + [postMessage](https://developer.mozilla.org/en-US/docs/Web/API/Window.postMessage)
# + [readystatechange](https://developer.mozilla.org/en-US/docs/Web/Reference/Events/readystatechange)
# + [setTimeout](https://developer.mozilla.org/en/docs/Web/API/window.setTimeout)
#
# The order has been chosen from best to worst for both performance and
# preemptiveness.
class Immediate
  # Create an immediate for the given function which will be called with the
  # arguments and block.
  #
  # @param func [Proc] the function to call
  # @param args [Array] the arguments to call it with
  def initialize(func, args, &block)
    @aborted   = false
    @function  = func
    @arguments = args
    @block     = block
  end

  # @!method dispatch
  #   Dispatch the immediate.

  # @!method prevent
  #   Prevent the immediate from being called once scheduled.
  if Browser.supports? 'Immediate'
    def dispatch
      @id = `window.setImmediate(function() {
        #{@function.call(*@arguments, &@block)};
      })`
    end

    def prevent
      `window.clearImmediate(#@id)`
    end
  elsif Browser.supports? 'Immediate (Internet Explorer)'
    def dispatch
      @id = `window.msSetImmediate(function() {
        #{@function.call(*@arguments, &@block)};
      })`
    end

    def prevent
      `window.msClearImmediate(#@id)`
    end
  elsif Browser.supports? 'Window.send (Asynchronous)'
    # @private
    @@tasks  = {}

    # @private
    @@prefix = "opal.browser.immediate.#{rand(1_000_000)}."

    $window.on :message do |e|
      if String === e.data && e.data.start_with?(@@prefix)
        if task = @@tasks.delete(e.data[@@prefix.length .. -1])
          task[0].call(*task[1], &task[2])
        end
      end
    end

    def dispatch
      @id          = rand(1_000_000).to_s
      @@tasks[@id] = [@function, @arguments, @block]

      $window.send "#{@@prefix}#{@id}"
    end

    def prevent
      @@tasks.delete(@id)
    end
  elsif Browser.supports? 'Event.readystatechange'
    def dispatch
      %x{
        var script = document.createElement("script");

        script.onreadystatechange = function() {
          if (!#{aborted?}) {
            #{@function.call(*@arguments, &@block)};
          }

          script.onreadystatechange = null;
          script.parentNode.removeChild(script);
        };

        document.documentElement.appendChild(script);
      }
    end

    def prevent; end
  else
    def dispatch
      @id = `window.setTimeout(function() {
        #{@function.call(*@arguments, &@block)};
      }, 0)`
    end

    def prevent
      `window.clearTimeout(#@id)`
    end
  end

  # Abort the immediate.
  def abort
    return if aborted?

    @aborted = true
    prevent

    self
  end

  # Check if the immediate has been aborted.
  def aborted?
    @aborted
  end
end

end

module Kernel
  # (see Immediate.new)
  def defer(*args, &block)
    Browser::Immediate.new(block, args).tap(&:dispatch)
  end
end

class Proc
  # (see Immediate.new)
  def defer(*args, &block)
    Browser::Immediate.new(self, args, &block).tap(&:dispatch)
  end
end

class Promise
  # Create a promise which will be resolved with the result of the immediate.
  #
  # @param args [Array] the arguments the block will be called with
  def self.defer(*args, &block)
    new.tap {|promise|
      proc {
        begin
          promise.resolve(block.call(*args))
        rescue Exception => e
          promise.reject(e)
        end
      }.defer
    }
  end
end
