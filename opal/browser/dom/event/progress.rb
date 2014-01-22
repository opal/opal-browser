module Browser; module DOM; class Event

class Progress < Event
  def self.supported?
    not $$[:ProgressEvent].nil?
  end

  class Definition < Definition
    def computable=(value)
      `#@native.computableLength = #{value}`
    end

    def loaded=(value)
      `#@native.loaded = #{value}`
    end

    def total=(value)
      `#@native.total = #{value}`
    end
  end

  def self.construct(name, desc)
    `new ProgressEvent(#{name}, #{desc})`
  end

  alias_native :computable?, :computableLength
  alias_native :loaded
  alias_native :total
end

end; end; end
