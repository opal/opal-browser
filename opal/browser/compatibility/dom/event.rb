require 'browser/compatibility/dom/event/base/attach'
require 'browser/compatibility/dom/event/base/detach'
require 'browser/compatibility/dom/event/base/dispatch'

require 'browser/compatibility/dom/event/mouse'
require 'browser/compatibility/dom/event/custom'

module Browser; module DOM; class Event

if Browser.supports? :event, :constructor
  def self.construct(name, desc)
    `new Event(#{name}, #{desc})`
  end
elsif Browser.supports? :event, :create
  def self.construct(name, desc)
    %x{
      var event = document.createEvent("HTMLEvents");
          event.initEvent(name, desc.bubbles, desc.cancelable);

      return event;
    }
  end
elsif Browser.supports? :event, :createObject
  def self.construct(name, desc)
    Native(`document.createEventObject()`) \
      .merge!(`{ type: name }`) \
      .merge!(desc) \
      .to_n
  end
else
  def self.construct(name, desc)
    Native(desc).merge!(`{ type: name }`).to_n
  end
end

end; end; end
