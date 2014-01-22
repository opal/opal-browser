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

  def self.construct(name, desc)
    `new AnimationEvent(#{name}, #{desc})`
  end

  alias_native :name, :animationName
  alias_native :elapsed, :elapsedTime
end

end; end; end
