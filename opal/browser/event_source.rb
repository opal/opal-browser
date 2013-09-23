module Browser

# This class wraps `EventSource`.
class EventSource
  include Native::Base
  include DOM::Event::Target

  target {|value|
    EventSource.new(value) if `window.EventSource && #{value} instanceof window.EventSource`
  }

  # Create an {EventSource} on the given path.
  #
  # @param path [String] the path to use as source
  # @yield if the block has no parameters it's instance_exec'd, otherwise it's
  #        called with self
  def initialize(path, &block)
    if native?(path)
      super(path)
    else
      super(`new window.EventSource(path)`)
    end

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end if block
  end

  alias_native :url

  def state
    %x{
      switch (#@native.readyState) {
        case window.EventSource.CONNECTING:
          return "connecting";

        case window.EventSource.OPEN:
          return "open";

        case window.EventSource.CLOSED:
          return "closed";
      }
    }
  end

  def alive?
    state == :open
  end

  def close
    `#@native.close()`
  end
end

end
