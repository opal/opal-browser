# backtick_javascript: true

module Browser; class Event

class Animation < Event
  handles 'animationend', 'animationiteration', 'animationstart'

  def self.supported?
    Browser.supports? 'Event.Animation'
  end

  class Definition < Definition
    alias_native :name=, :animationName=
    alias_native :animation=, :animationName=
    alias_native :elapsed=, :elapsedTime=
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
