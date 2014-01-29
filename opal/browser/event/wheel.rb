module Browser; class Event

class Wheel < UI
  def self.supported?
    not $$[:WheelEvent].nil?
  end

  class Definition < Definition
    def x=(value)
      `#@native.deltaX = #{value}`
    end

    def y=(value)
      `#@native.deltaY = #{value}`
    end

    def z=(value)
      `#@native.deltaZ = #{value}`
    end

    def mode=(value)
      value = case value
        when :pixel then `WheelEvent.DOM_DELTA_PIXEL`
        when :line  then `WheelEvent.DOM_DELTA_LINE`
        when :page  then `WheelEvent.DOM_DELTA_PAGE`
      end

      `#@native.deltaMode = #{value}`
    end
  end

  def self.construct(name, desc)
    `new WheelEvent(#{name}, #{desc})`
  end

  alias_native :x, :deltaX
  alias_native :y, :deltaY
  alias_native :z, :deltaZ

  def mode
    case `#@native.deltaMode`
      when `WheelEvent.DOM_DELTA_PIXEL` then :pixel
      when `WheelEvent.DOM_DELTA_LINE`  then :line
      when `WheelEvent.DOM_DELTA_PAGE`  then :page
    end
  end
end

end; end
