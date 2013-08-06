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

  def self.create(name, &block)
    new(`new AnimationEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :name, :animationName
  alias_native :elapsed, :elapsedTime
end

end; end; end
