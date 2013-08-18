module Browser

class EventSource
  include Native::Base
  include DOM::Event::Target

  converter {|value|
    EventSource.new(value) if `window.EventSource && #{value} instanceof EventSource`
  }

  def initialize(path)
    if native?(path)
      super(path)
    else
      super(`new EventSource(path)`)
    end
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
