module Browser; class Event

class Animation < Event
  def self.supported?
    Browser.supports? 'Event.Animation'
  end

  class Definition < Definition
    def animation=(value)
      `#@native.animationName = #{value}`
    end

    def elapsed=(value)
      `#@native.elapsedTime = #{value}`
    end
  end

  if Browser.supports? 'Event.constructor'
    def self.construct(name, desc)
      `new AnimationEvent(#{name}, #{desc})`
    end
  elsif Browser.supports? 'Event.create'
    def self.construct(name, desc)
      %x{
        var event = document.createEvent("AnimationEvent");
            event.initAnimationEvent(name, desc.bubbles, desc.cancelable,
              desc.animationName, desc.elapsedTime);

        return event;
      }
    end
  end if supported?

  alias_native :name, :animationName
  alias_native :elapsed, :elapsedTime
end

end; end
