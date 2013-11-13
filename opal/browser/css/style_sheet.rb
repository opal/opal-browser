module Browser; module CSS

class StyleSheet
  include Native

  def initialize(what)
    if what.is_a? DOM::Element
      super(`#{what.to_n}.sheet`)
    else
      super(what)
    end
  end

  alias_native :disabled?, :disabled
  alias_native :href
  alias_native :title
  alias_native :type

  def media
    Media.new(`#@native.media`) if `#@native.media != null`
  end

  def owner
    DOM(`#@native.ownerNode`)
  end

  def parent
    Sheet.new(`#@native.parentStyleSheet`) if `#@native.parentStyleSheet != null`
  end

  def rules
    Native::Array.new(`#@native.cssRules`) { |e|
      Rule.new(e)
    }
  end

  def delete(index)
    `#@native.deleteRule(index)`
  end

  def insert(index, rule)
    `#@native.insertRule(#{rule}, #{index})`
  end

  def rule(selector, body)
    unless String === selector
      selector = selector.join ', '
    end

    unless String === body
      body = body.map {|name, value|
        "#{name}: #{value};"
      }.join "\n"
    end

    insert(length, "#{selector} { #{body} }")
  end

  def [](id)
    rules.find { |r| log r; r.id == id }
  end

  def method_missing(*args, &block)
    rules.__send__(*args, &block)
  end

  class Media < Native::Array
    alias_native :text, :mediaText
    alias_native :to_s, :mediaText

    def push(medium)
      `#@native.appendMedium(#{medium})`

      self
    end

    def delete(medium)
      `#@native.deleteMedium(#{medium})`
    end
  end
end

end; end
