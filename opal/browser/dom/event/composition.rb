module Browser; module DOM; class Event

class Composition < UI
  def self.supported?
    not $$[:CompositionEvent].nil?
  end

  class Definition < UI::Definition
    def data=(value)
      `#@native.data = #{value}`
    end

    def locale=(value)
      `#@native.locale = #{value}`
    end
  end

  def self.construct(name, desc)
    `new CompositionEvent(#{name}, #{desc})`
  end

  alias_native :data
  alias_native :locale

  def start?
    name.downcase == 'compositionstart'
  end

  def update?
    name.downcase == 'compositionupdate'
  end

  def end?
    name.downcase == 'compositionend'
  end
end

end; end; end
