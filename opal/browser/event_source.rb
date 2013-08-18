module Browser

class EventSource
  include Native::Base
  include DOM::Event::Target

  converter {|value|
    EventSource.new(value) if `window.EventSource && #{value} instanceof EventSource`
  }

  def initialize(path, &block)
    if native?(path)
      super(path)
    else
      super(`new EventSource(path)`)
    end

    if block.arity == 0
      instance_exec(&block)
    else
      block.call(self)
    end if block
  end

  alias_native :url, :url

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
end

end
