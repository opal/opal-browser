module Browser; module DOM; class Event

class Focus < UI
  def self.supported?
    not $$[:FocusEvent].nil?
  end

  class Definition < UI::Definition
    def related=(elem)
      `#@native.relatedTarget = #{Native.try_convert(elem)}`
    end
  end

  def self.construct(name, desc)
    `new FocusEvent(#{name}, #{desc})`
  end

  def related
    DOM(`#@native.relatedTarget`)
  end
end

end; end; end
