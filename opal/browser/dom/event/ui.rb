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

  def self.create(name, &block)
    new(`new UIEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :detail, :detail
  alias_native :view, :view
end

end; end; end
