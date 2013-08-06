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

  def self.create(name, &block)
    new(`new PageTransitionEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :persisted?, :persisted
end

end; end; end
