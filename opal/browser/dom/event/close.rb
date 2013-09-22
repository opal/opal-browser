module Browser; module DOM; class Event

class Close < Event
  def self.supported?
    not $$[:CloseEvent].nil?
  end

  class Definition < Definition
    def code=(value)
      `#@native.code = #{value}`
    end

    def reason=(value)
      `#@native.reason = #{value}`
    end

    def clean!(value)
      `#@native.wasClean = true`
    end

    def not_clean!(value)
      `#@native.wasClean = false`
    end
  end

  def self.create(name, &block)
    new(`new CloseEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :code
  alias_native :reason
  alias_native :clean?, :wasClean
end

end; end; end
