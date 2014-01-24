module Browser; module DOM; class Event; class Animation < Event

if Browser.supports? :event, :constructor
  def self.construct(name, desc)
    `new AnimationEvent(#{name}, #{desc})`
  end
elsif Browser.supports? :event, :create
  def self.construct(name, desc)
    %x{
      var event = document.createEvent("AnimationEvent");
          event.initAnimationEvent(name, desc.bubbles, desc.cancelable,
            desc.animationName, desc.elapsedTime);

      return event;
    }
  end
elsif Browser.supports? :event, :createObject
  def self.construct(name, desc)
    Native(`document.createEventObject()`).merge!(desc).to_n
  end
else
  def self.construct(*)
    raise NotImplementedError
  end
end

end; end; end; end
