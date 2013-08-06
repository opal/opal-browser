module Browser; module DOM; class Event

# TODO: handle transfers
class Drag < Event
  def self.supported?
    not $$[:DragEvent].nil?
  end

  class Definition < Definition
    class Client
      include Native::Base

      def x=(value)
        `#@native.clientX = #{value}`
      end

      def y=(value)
        `#@native.clientY = #{value}`
      end
    end

    class Screen
      include Native::Base

      def x=(value)
        `#@native.screenX = #{value}`
      end

      def y=(value)
        `#@native.screenY = #{value}`
      end
    end

    def alt!
      `#@native.altKey = true`
    end

    def ctrl!
      `#@native.ctrlKey = true`
    end

    def meta!
      `#@native.metaKey = true`
    end

    def button=(value)
      `#@native.button = #{value}`
    end

    def client
      Client.new(@native)
    end

    def screen
      Screen.new(@native)
    end

    def related=(elem)
      `#@native.relatedTarget = #{Native.try_convert(elem)}`
    end



  end

  def self.create(name, &block)
    new(`new DragEvent(#{name}, #{Definition.new(&block)})`)
  end

  Position = Struct.new(:x, :y)

  def alt?
    `#@native.altKey`
  end

  def ctrl?
    `#@native.ctrlKey`
  end

  def meta?
    `#@native.metaKey`
  end

  def shift?
    `#@native.shiftKey`
  end

  def button
    `#@native.button`
  end

  def client
    Position.new(`#@native.clientX`, `#@native.clientY`)
  end

  def screen
    Position.new(`#@native.screenX`, `#@native.screenY`) if defined?(`#@native.screenX`)
  end

  def x
    screen.x
  end

  def y
    screen.y
  end

  def related
    DOM(`#@native.relatedTarget`)
  end
end

end; end; end
