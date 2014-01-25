module Browser; module DOM; class Event

class Animation < Event
  def self.supported?
    not $$[:AnimationEvent].nil?
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
  elsif Browser.supports? 'Event.createObject'
    def self.construct(name, desc)
      Native(`document.createEventObject()`).merge!(desc).to_n
    end
  else
    def self.construct(*)
      raise NotImplementedError
    end
  end

  alias_native :name, :animationName
  alias_native :elapsed, :elapsedTime
end

end; end; end
