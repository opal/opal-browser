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

  def self.create(name, &block)
    new(`new ProgressEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :computable?, :computableLength
  alias_native :loaded, :loaded
  alias_native :total, :total
end

end; end; end
