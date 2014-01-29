module Browser

# An {EventSource} allows you to receive events from a server in real-time,
# similar to long-polling but not exactly.
#
# @see https://developer.mozilla.org/en-US/docs/Web/API/EventSource
class EventSource
  def self.supported?
    Browser.supports? :EventSource
  end

  include Native
  include Event::Target

  target {|value|
    EventSource.new(value) if Native.is_a?(value, `window.EventSource`)
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

  # @!attribute [r] url
  # @return [String] the URL of the event source
  alias_native :url

  # @!attribute [r] state
  # @return [:connecting, :open, :closed] the state of the event source
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

  # Check if the event source is alive.
  def alive?
    state == :open
  end

  # Close the event source.
  def close
    `#@native.close()`
  end
end

end
