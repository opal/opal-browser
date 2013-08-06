module Browser; module DOM; class Event

class HashChange < Event
  def self.supported?
    not $$[:HashChangeEvent].nil?
  end

  class Definition < Definition
    def old=(value)
      `#@native.oldURL = #{value}`
    end

    def new=(value)
      `#@native.newURL = #{value}`
    end
  end

  def self.create(name, &block)
    new(`new HashChangeEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :old, :oldURL
  alias_native :new, :newURL
end

end; end; end
