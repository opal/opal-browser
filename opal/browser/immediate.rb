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
#
# @todo drop the method_defined? checks when require order is fixed
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

  # Dispatch the immediate.
  #
  # @abstract
  def dispatch
    raise NotImplementedError
  end unless method_defined? :dispatch

  # Prevent the immediate from being called once scheduled.
  #
  # @abstract
  def prevent
    raise NotImplementedError
  end unless method_defined? :prevent

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

require 'browser/compatibility/immediate'
