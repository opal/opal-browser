module Browser; module DOM; class Event < Native

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

  def self.create(name, &block)
    new(`new CompositionEvent(#{name}, #{Definition.new(&block)})`)
  end

  alias_native :data, :data
  alias_native :locale, :locale

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
