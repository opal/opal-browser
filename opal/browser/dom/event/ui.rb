module Browser; module DOM; class Event

class UI < Event
  class Definition < Definition
    def detail=(value)
      `#@native.detail = #{value}`
    end

    def view=(value)
      `#@native.view = #{value}`
    end
  end

  def self.construct(name, desc)
    `new UIEvent(#{name}, #{desc})`
  end

  alias_native :detail
  alias_native :view
end

end; end; end
