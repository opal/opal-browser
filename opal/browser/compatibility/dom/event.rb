require 'browser/compatibility/dom/event/base/attach'
require 'browser/compatibility/dom/event/base/detach'
require 'browser/compatibility/dom/event/base/dispatch'

require 'browser/compatibility/dom/event/mouse'
require 'browser/compatibility/dom/event/custom'

module Browser; module DOM; class Event

unless C.new_event?
  if C.create_event?
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("HTMLEvents");
            event.initEvent(name, desc.bubbles, desc.cancelable);

        return event;
      }
    end
  else
  end
end

end; end; end
