module Browser; module DOM; class Event

class Clipboard < Event
  def self.supported?
    not $$[:ClipboardEvent].nil?
  end

  class Definition < Definition
    def data=(value)
      `#@native.data = #{value}`
    end

    def type=(value)
      `#@native.dataType = #{value}`
    end
  end

  def self.create(name, &block)
    new(`new ClipboardEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :data, :data
  alias_native :type, :dataType
end

end; end; end
