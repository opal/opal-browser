module Browser; module CSS

class StyleSheet
  include Native::Base

  alias_native :disabled?, :disabled
  alias_native :href, :href
  alias_native :media, :media
  alias_native :title, :title
  alias_native :type, :type

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

  def method_missing(*args, &block)
    rules.__send__(*args, &block)
  end
end

end; end
