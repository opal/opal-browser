module Browser; module DOM; class Event

class PageTransition < Event
  def self.supported?
    not $$[:PageTransitionEvent].nil?
  end

  class Definition < Definition
    def persisted=(value)
      `#@native.persisted = #{value}`
    end
  end

  def self.construct(name, desc)
    `new PageTransitionEvent(#{name}, #{desc})`
  end

  alias_native :persisted?, :persisted
end

end; end; end
