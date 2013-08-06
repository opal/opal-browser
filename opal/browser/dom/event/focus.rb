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

  def self.create(name, &block)
    new(`new FocusEvent(#{name}, #{Definition.new(&block)})`)
  end

  def related
    DOM(`#@native.relatedTarget`)
  end
end

end; end; end
