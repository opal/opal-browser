module Browser; module DOM; class Event < Native

class Gamepad < Event
  def self.supported?
    not $$[:GamepadEvent].nil?
  end

  class Definition < Definition
    def initialize(*)
      super

      `#@native.gamepad = {}`
    end

    def id=(value)
      `#@native.gamepad.id = #{value}`
    end

    def index=(value)
      `#@native.gamepad.index = #{value}`
    end

    def timestamp=(value)
      `#@native.gamepad.timestamp = #{value}`
    end

    def axes=(value)
      `#@native.gamepad.axes = #{value}`
    end

    def buttons=(value)
      `#@native.gamepad.buttons = #{value}`
    end
  end

  def self.create(name, &block)
    new(`new GamepadEvent(#{name}, #{Definition.new(&block)})`)
  end

  %w(id index timestamp axes buttons).each {|name|
    define_method name do
      `#@native.gamepad[#{name}]`
    end
  }
end

end; end; end
