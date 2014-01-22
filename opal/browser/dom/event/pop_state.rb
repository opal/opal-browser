module Browser; module DOM; class Event

class PopState < Event
  def self.supported?
    not $$[:PopStateEvent].nil?
  end

  class Definition < Definition
    def state=(value)
      `#@native.state = #{value}`
    end
  end

  def self.construct(name, desc)
    `new PopStateEvent(#{name}, #{desc})`
  end

  alias_native :state
end

end; end; end
